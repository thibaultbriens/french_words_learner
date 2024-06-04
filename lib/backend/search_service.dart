
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:french_words_learner/shared/word.dart';

class SearchService{

  Future<List<String>> get allWords async {
    String fileString = await rootBundle.loadString('assets/dictionary.json');
    var jsonObject = jsonDecode(fileString);

    return jsonObject.keys.toList();
  }

  Future<Word> wordNameToObject(String word) async {

    String fileString = await rootBundle.loadString('assets/dictionary.json');
    var jsonObject = jsonDecode(fileString);

    Map<String, dynamic> wordData = jsonDecode(jsonObject[word]);

    List<dynamic> defs = wordData["definitions"];
    List<dynamic> syn = wordData["synonymous"];
    List<dynamic> opp = wordData["opposites"];

    return Word(
      word: word,
      definitions: defs.map((e) => e.toString()).toList(),
      synonymous: syn.map((e) => e.toString()).toList(),
      opposites: opp.map((e) => e.toString()).toList(),
    );
  }

  Future<List<String>> nextWords(String text) async {
    String fileString = await rootBundle.loadString('assets/dictionary.json');
    var jsonObject = jsonDecode(fileString);

    int i = 0;
    List<String> result = [];

    for(String el in jsonObject.keys.toList()){
      if(i >= 30){
        break;
      }
      if(el.startsWith(text)){
        result.add(el);
        i++;
      }
    }

      return result;
  }
}