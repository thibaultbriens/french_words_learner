import 'package:flutter/material.dart';
import 'package:french_words_learner/backend/learning_service.dart';

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
              ? Text("Not a soul here...")
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
                                  title:
                                      Text("Delete the word from the list ?"),
                                  actions: [
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red),
                                        onPressed: () {
                                          LearningService().removeWord(learningStateWords[index]);
                                          Navigator.pop(context);
                                          setState(() {});
                                        },
                                        child: Text("Yes")),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("No")),
                                  ],
                                );
                              });
                        },
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
