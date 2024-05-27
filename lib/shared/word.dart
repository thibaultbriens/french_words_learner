//import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class Word{
  String word;
  List<String> definitions;
  List<String> synonymous;
  List<String> opposites;

  Word({
    required this.word,
    required this.definitions,
    required this.synonymous,
    required this.opposites
  });

  @override
  String toString() {
    // TODO: implement toString
    return this.word + "\n" + this.definitions.toString() + "\n" + "${this.synonymous ?? "[]"}" + "\n" + "${this.opposites ?? "[]"}";
  }

  String toJson(){
    String jsonString = '''
{
  "definitions": ${definitions.map((e) => '''"$e"''').toList()},
  "synonymous": ${synonymous.map((e) => '''"$e"''').toList()},
  "opposites": ${opposites.map((e) => '''"$e"''').toList()}
}''';

    return jsonString;
  }

  Widget buildWordInfo(){
    return ListView(
      shrinkWrap: true,
      children: [
        Text(word, textScaler: TextScaler.linear(1.8),),
        ListView.builder(
          shrinkWrap: true,
          itemCount: definitions.length,
          itemBuilder: (context, index){
            return Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(child: Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(definitions[index],),
                  ))
                ],
              ),
            );
          }
        ),
        // synonymous != null && synonymous!.isNotEmpty? Flexible(child: Text("Synonymes: ${buildSynonymousText(synonymous!)}")) : Container(),
        // opposites != null && opposites!.isNotEmpty? Flexible(child: Text("Contraires: ${buildSynonymousText(opposites!)}")) : Container(),
      ],
    );
  }
  
  String buildSynonymousText(List<Word> synonymous) { // synonymous can also be 'opposites' list
    String result = "";

    for(int i = 0; i < synonymous.length - 1; i++){
      result += synonymous[i].word + ", ";
    }

    return result + synonymous[synonymous.length - 1].word;
  }
}