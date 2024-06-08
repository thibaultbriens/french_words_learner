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

  /*Widget buildWordInfo(){
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
              child: Flexible(child: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(definitions[index],),
              )),
            );
          }
        ),
        synonymous.isNotEmpty? Flexible(child: Text("Synonymes: ${buildSynonymousText(synonymous)}")) : Container(),
        opposites.isNotEmpty? Flexible(child: Text("Contraires: ${buildSynonymousText(opposites)}")) : Container(),
      ],
    );
  }*/

   Widget buildWordInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(word, textScaler: TextScaler.linear(1.8),),
        SizedBox(height: 10),
        ...definitions.map((definition) => Padding(
          padding: const EdgeInsets.only(left: 12, top: 4),
          child: Text(definition),
        )).toList(),
        SizedBox(height: 10),
        if (synonymous.isNotEmpty) Text("Synonymes:\n${buildSynonymousText(synonymous)}"),
        SizedBox(height: 5,),
        if (opposites.isNotEmpty) Text("Contraires:\n${buildSynonymousText(opposites)}"),
      ],
    );
  }
  
  String buildSynonymousText(List<String> synonymous) { // synonymous can also be 'opposites' list
    String result = "";

    for(int i = 0; i < synonymous.length - 1; i++){
      result += synonymous[i] + ", ";
    }

    return result + synonymous[synonymous.length - 1];
  }
}