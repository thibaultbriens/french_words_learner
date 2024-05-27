import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class SuccessLearn extends StatelessWidget {



  SuccessLearn({super.key}){
    playConfetti();
  }

  final List<ConfettiController> _confettiCtrls = [ConfettiController(duration: const Duration(milliseconds: 800)), ConfettiController(duration: const Duration(milliseconds: 800)), ConfettiController(duration: const Duration(milliseconds: 800)), ConfettiController(duration: const Duration(milliseconds: 800))];
  double frequency = 0.07;
  int nbParticles = 8;
  


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Stack(
        children: [
          // confettis
          Align(
            alignment: Alignment.centerLeft,
            child: ConfettiWidget(
              confettiController: _confettiCtrls[0],
              blastDirectionality: BlastDirectionality.explosive,
              //shouldLoop: false,
              blastDirection: -3 *pi/4,
              emissionFrequency: frequency,
              numberOfParticles: nbParticles,
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiCtrls[1],
              blastDirectionality: BlastDirectionality.explosive,
              //shouldLoop: false,
              blastDirection: 3*pi/4,
              emissionFrequency: frequency,
              numberOfParticles: nbParticles,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: ConfettiWidget(
              confettiController: _confettiCtrls[2],
              blastDirectionality: BlastDirectionality.explosive,
              //shouldLoop: false,
              blastDirection: pi,
              emissionFrequency: frequency,
              numberOfParticles: nbParticles,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ConfettiWidget(
              confettiController: _confettiCtrls[3],
              blastDirectionality: BlastDirectionality.explosive,
              //shouldLoop: false,
              blastDirection: -pi/2,
              emissionFrequency: frequency,
              numberOfParticles: nbParticles,
            ),
          ),
          // main children
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                child: Text("Congrats !", style: TextStyle(fontSize: 18),),
                onTap: (){
                  print("Tapped");
                  playConfetti();
                },
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
              ),
              Text("You have no more words to learn", style: TextStyle(fontSize: 18),),
            ],
          ),
        ],
      ),
    );
  }

  void playConfetti(){
    for(var el in _confettiCtrls){
      el.play();
    }
  }
}