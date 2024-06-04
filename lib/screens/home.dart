import 'package:flutter/material.dart';
import 'package:french_words_learner/screens/learn/learn.dart';
import 'package:french_words_learner/screens/search/search.dart';
import 'package:french_words_learner/screens/settings/settings.dart';
import 'package:french_words_learner/shared/bottom_app_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int screenIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 2,),
      body: screenIndex == 0 
        ? Learn()
        : screenIndex == 1 
          ? Search()
          : Settings(),
      bottomNavigationBar: MyBottomAppBar(changeIndex),
    );
  }

  void changeIndex(int i){
    if (screenIndex != i){
      setState(() {
        screenIndex = i;
      });
    }
  }
}
