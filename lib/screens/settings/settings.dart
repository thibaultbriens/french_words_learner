// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:french_words_learner/backend/notifications_service.dart';
import 'package:french_words_learner/screens/settings/learning_state.dart';
import 'package:french_words_learner/shared/loader.dart';
import 'package:localstore/localstore.dart';
import 'package:provider/provider.dart';

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
          SizedBox(height: 10,),
          Text("Préférences", style: TextStyle(fontSize: 19)),
          SizedBox(height: 4,),
          Card(
            color: Colors.white,
            child: ListTile(
              leading: Icon(Icons.access_time_rounded),
              title: Text("Heure de rappel", style: TextStyle(fontSize: 14),),
              onTap: () {
                showDialog(context: context, builder: (context){
                  return HourSelectorDialog();
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class HourSelectorDialog extends StatelessWidget {
  const HourSelectorDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<int>>(
      future: NotificationSercice().getHourMinute(),
      builder: (context, snapshot) {

        if(snapshot.connectionState == ConnectionState.waiting){
          return Loader();
        }

        if(snapshot.hasError){
          return Text("Snapshot error");
        }

        int hour = snapshot.data![0];
        int minute = snapshot.data![1];

        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              child: Container(
                padding: EdgeInsets.all(25),
                width: MediaQuery.of(context).size.width / 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Choisissez une heure", style: TextStyle(fontSize: 19),),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 55,
                          child: DropdownButtonFormField<int>(
                            menuMaxHeight: MediaQuery.of(context).size.height / 3,
                            value: hour,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 10),
                              border: OutlineInputBorder(),
                            ),
                            icon: Icon(Icons.arrow_drop_down),
                            items: List.generate( 24, (index) => DropdownMenuItem<int>(value: index, child: Text('$index',),),
                            ),
                            onChanged: (int? newValue) {
                              setState(() {
                                hour = newValue!;
                              });
                            },
                          ),
                        ),
            
                        SizedBox(width: 5,),
                        Text(":", style: TextStyle(fontSize: 22),),
                        SizedBox(width: 5,),
            
                        Container(
                          width: 55,
                          child: DropdownButtonFormField<int>(
                            menuMaxHeight: MediaQuery.of(context).size.height / 3,
                            value: minute,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 10),
                              border: OutlineInputBorder(),
                            ),
                            icon: Icon(Icons.arrow_drop_down),
                            items: List.generate( 12 /* 60 / 5 */, (index) => DropdownMenuItem<int>(value: index, child: Text('${index * 5}',),),
                            ),
                            onChanged: (int? newValue) {
                              setState(() {
                                minute = newValue!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
            
                    SizedBox(height: 25,),
            
                    Container(
                      alignment: Alignment.centerRight,
                      height: 40,
                      child: ElevatedButton(
                        child: Text("Confirmer", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                        ),
                        onPressed: () async {
                          // Update notification hour
                          await NotificationSercice().updateTime(hour, minute);
                          Navigator.pop(context);
                        },
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        );
      }
    );
  }
}

