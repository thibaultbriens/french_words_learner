// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:french_words_learner/screens/settings/learning_state.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Apprentissage", style: TextStyle(fontSize: 19)),
          SizedBox(height: 4,),
          Card(
            color: Colors.white,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.star_half_sharp),
                  title: Text("En apprentissage", style: TextStyle(fontSize: 14),),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LearningState()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.done),
                  title: Text("Déjà appris avec nous", style: TextStyle(fontSize: 14),),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Bientot disponible"), duration: Duration(seconds: 1),));
                  },
                )
              ],
            ),
          ),
          /*ListTile(
            leading: Icon(Icons.pending),
            title: Text("Test notifications", style: TextStyle(fontSize: 14),),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => TestNotif()));
            },
          )*/
        ],
      ),
    );
  }
}