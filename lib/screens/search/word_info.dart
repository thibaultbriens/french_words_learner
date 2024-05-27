import 'package:flutter/material.dart';
import 'package:french_words_learner/backend/learning_service.dart';
import 'package:french_words_learner/shared/loader.dart';
import 'package:french_words_learner/shared/word.dart';

class WordInfo extends StatefulWidget {

  Word word;

  WordInfo(this.word);

  @override
  State<WordInfo> createState() => _WordInfoState();
}

class _WordInfoState extends State<WordInfo> {
  bool wordInLearningList = false; 
 // if word is in learning list
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton.filled(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back)
        ),
        actions: [
          buildAddOrDeleteButton()
        ],     
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
        child: widget.word.buildWordInfo(),
      ),
    );
  }

  Widget buildAddOrDeleteButton(){
    return FutureBuilder(
      future: LearningService().inLearningWords,
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return Loader();
        }

        if(snapshot.hasError){
          return Text("Snapshot error: ${snapshot.error}");
        }

        bool wordInLearningList = snapshot.data!.contains(widget.word.word);

        return IconButton.filled(
          onPressed: (){
            if(wordInLearningList){
              LearningService().removeWord(widget.word.word);
              setState(() {});
            }
            else{
              LearningService().addWord(widget.word.word);
              setState(() {});
            }
          },
          icon: Icon(wordInLearningList ? Icons.delete : Icons.add)
        );
      }
    );
  }
}