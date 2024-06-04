import 'package:flutter/material.dart';
import 'package:french_words_learner/onboarding_ui/onboarding.dart';
import 'package:french_words_learner/screens/home.dart';
import 'package:localstore/localstore.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  int index = 1; // 0 means Onboarding() and 1 means Home()

  void goToHome(){
    setState(() {
      index = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: onboardingVal,
      builder: (context, snapshot) {

        if(snapshot.connectionState == ConnectionState.waiting){
          return Scaffold();
        }

        if(snapshot.data == false){
          index = 0;
        }

        return index == 0 ? Onboarding(goToHome, onboardingDone) : Home();
      }
    );
  }
}

Future<bool> get onboardingVal async {
  return (await Localstore.instance.collection("static").doc("app").get() ?? {"onboardingDone": false})["onboardingDone"];
}

Future onboardingDone() async {
  await  Localstore.instance.collection("static").doc("app").set({
    "onboardingDone": true
  }, SetOptions(merge: true));
}