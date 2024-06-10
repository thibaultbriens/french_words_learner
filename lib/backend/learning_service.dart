import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:french_words_learner/backend/notifications_service.dart';
import 'package:french_words_learner/backend/search_service.dart';
import 'package:french_words_learner/shared/word.dart';
import 'package:localstore/localstore.dart';

class LearningService{

  final int lastLevel = 8;
  final int firstLevel = 1;

  final db = Localstore.instance;

  final NotificationSercice _notifService = NotificationSercice();

  List<Duration> durationOnLevel = [
    Duration(days: 1),
    Duration(days: 1),
    Duration(days: 2),
    Duration(days: 3),
    Duration(days: 7),
    Duration(days: 15),
    Duration(days: 30),
    Duration(days: 60),
  ];

  /// Get {level, lastly-seen} values of the word
  Future<Map<String, dynamic>> wordInfo (String word) async{ 
    return await db.collection("learning").doc(word).get() ?? {};
  }

  /// Get current learnedList
  Future<List<String>> get learnedList async {
    final Map<String, dynamic>? data = await db.collection("learned").doc("doc").get();

    if(data == null || data.isEmpty)
      return [];
    else
      return data["learned-list"];
  }

  /// Add a word to learning list
  void addWord (String word) {
    print("Adding word = $word");
    db.collection("learning").doc(word).set({
      "level": firstLevel,
      "lastly-seen": DateTime.now().millisecondsSinceEpoch
    });
    //SetOptions(merge: true));

    // add notification
    _notifService.addWordNotification(date: DateTime.now().add(Duration(days: 1)));
  }

  /// Delete a word from learning list
  void removeWord(String word){
    db.collection("learning").doc(word).delete();
  }

  /// Add a level to a word
  void addLevel(String word) async{
    
    Map<String, dynamic> wordParameters = await wordInfo(word);

    if(wordParameters == null)
      return;

    int currentLevel = wordParameters["level"];
    DateTime lastlySeen = DateTime.fromMillisecondsSinceEpoch(wordParameters["lastly-seen"]);

    if(currentLevel == lastLevel){
      // word is known
      wordComplete(word);
    }
    else{
      db.collection("learning").doc(word).set({
        "level": currentLevel + 1,
        "lastly-seen": DateTime.now().millisecondsSinceEpoch
      }, 
      SetOptions(merge: true));

      // add notification
      _notifService.addWordNotification(date: DateTime.now().add(durationOnLevel[currentLevel + 1 - 1]));
    }
  }
  
  /// Function called when a word reaches max level and is swiped right (good answer from user)
  void wordComplete(String word) async{
    // get current list
    List<String> currentLearnedList = await learnedList;
    currentLearnedList.add(word);
    // add to learned list
    db.collection("learned").doc("doc").set({
      "learned-list": currentLearnedList
    }, 
    SetOptions(merge: true));
  }

  /// Remove a level to a word
  void removeLevel(String word) async{
    
    Map<String, dynamic>? wordParameters = await wordInfo(word);

    if(wordParameters == null)
      return;

    int currentLevel = wordParameters["level"];
    DateTime lastlySeen = DateTime.fromMillisecondsSinceEpoch(wordParameters["lastly-seen"]);

    db.collection("learning").doc(word).set({
      "level": (currentLevel - 1).clamp(firstLevel, lastLevel),
      "lastly-seen": DateTime.now().millisecondsSinceEpoch
    }, 
    SetOptions(merge: true));

    // add notification
    _notifService.addWordNotification(date: DateTime.now().add(durationOnLevel[(currentLevel - 1).clamp(firstLevel, lastLevel) - 1]));
  }


  /// Returns all the words currently in learning state
  Future<List<String>> get inLearningWords async {
    final Map<String, dynamic>? learningCol = await db.collection("learning").get();

    return learningCol == null ? [] : learningCol.keys.map((e) => e.replaceAll("/learning/", "")).toList();
  }

  /// Returns the Word objects to be learned today
  Future<List<Word>> get wordsToLearnToday async {

    List<Word> result = [];

    // get the learning collection
    final List<String> learningList = await inLearningWords; 

    for(String word in learningList){
      Map<String, dynamic> wordParams = await wordInfo(word);

      DateTime lastSeen = DateTime.fromMillisecondsSinceEpoch(wordParams["lastly-seen"]);
      int level = wordParams["level"];

      DateTime now = DateTime.now();
      Duration timeToNow = DateTime(now.year, now.month, now.day).difference(DateTime(lastSeen.year, lastSeen.month, lastSeen.day));

      // add Word to list if time to now is equal or higher than level time
      SearchService _searchService = SearchService();
      switch(level){
        case 1: 
          if(timeToNow.inDays >= 1){
            Word wordObj = await _searchService.wordNameToObject(word);
            result.add(wordObj);
          }
          break; 
        case 2: 
          if(timeToNow.inDays >= 1){
            Word wordObj = await _searchService.wordNameToObject(word);
            result.add(wordObj);
          }
          break; 
        case 3: 
          if(timeToNow.inDays >= 2){
            Word wordObj = await _searchService.wordNameToObject(word);
            result.add(wordObj);
          }
          break; 
        case 4: 
          if(timeToNow.inDays >= 3){
            Word wordObj = await _searchService.wordNameToObject(word);
            result.add(wordObj);
          }
          break; 
        case 5: 
          if(timeToNow.inDays >= 7){
            Word wordObj = await _searchService.wordNameToObject(word);
            result.add(wordObj);
          }
          break; 
        case 6: 
          if(timeToNow.inDays >= 15){
            Word wordObj = await _searchService.wordNameToObject(word);
            result.add(wordObj);
          }
          break; 
        case 7: 
          if(timeToNow.inDays >= 30){
            Word wordObj = await _searchService.wordNameToObject(word);
            result.add(wordObj);
          }
          break; 
        case 8: 
          if(timeToNow.inDays >= 60){
            Word wordObj = await _searchService.wordNameToObject(word);
            result.add(wordObj);
          }
          break; 
      }
    }

    return result;
  }

  /// Only for testing purposes
  /// Prints in the console the localstore file
  void printLocalstore() async {
    final Map<String, dynamic>? learningCol = await db.collection("learning").get();
    print(learningCol);
  }

  void updateWords(List<Word> rightSwipes, List<Word> leftSwipes) {
    // update right swipes => +1 level
    for(Word el in rightSwipes){
      addLevel(el.word);
    }

    // update left swipes => -1 level
    for(Word el in leftSwipes){
      removeLevel(el.word);
    }
  }
}