import 'package:flutter/material.dart';
import 'package:french_words_learner/backend/learning_service.dart';
import 'package:french_words_learner/backend/search_service.dart';
import 'package:french_words_learner/screens/search/word_info.dart';
import 'package:french_words_learner/shared/word.dart';

import '../../shared/loader.dart';

class LearningState extends StatefulWidget {
  const LearningState({super.key});

  @override
  State<LearningState> createState() => _LearningStateState();
}

class _LearningStateState extends State<LearningState> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Row(
          children: [
            SizedBox(width: 8,),
            IconButton.filled(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back)
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<String>>(
        future: LearningService().inLearningWords,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loader();
          }

          if (snapshot.hasError) {
            print(snapshot.error);
            return Text("Snapshot error: ${snapshot.error}");
          }

          List<String> learningStateWords = snapshot.data!;

          return learningStateWords.isEmpty
              ? Padding(padding: EdgeInsets.fromLTRB(25, 15, 0, 0), child: Text("Aucun mot en apprentissage\nAllez vite en ajouter dans l'onglet recherche"))
              : ListView.builder(
                padding: EdgeInsets.only(left: 10),
                  itemCount: learningStateWords.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(learningStateWords[index]),
                      trailing: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Supprimer de ma liste d'apprentissage"),
                                  actions: [
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("Annuler", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),)),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red),
                                        onPressed: () {
                                          LearningService().removeWord(learningStateWords[index]);
                                          Navigator.pop(context);
                                          setState(() {});
                                        },
                                        child: const Text("Oui", style: TextStyle(color: Colors.white),)),
                                  ],
                                );
                              });
                        },
                      ),
                      onTap: () async {
                        Word word = await SearchService().wordNameToObject(learningStateWords[index]);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                          builder:
                            (context) => WordInfo(word, onlyInfo: true,)
                          ),
                        );
                      },
                    );
                  },
                );
        },
      ),
    );
  }
}
