import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {

  final Widget image;
  final String title;
  final Widget? secondary;
  double heightPadding;
  double betweenPadding;

  OnboardingPage({
    super.key,
    required this.image,
    required this.title,
    this.secondary,
    this.heightPadding = 50,
    this.betweenPadding = 100
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: heightPadding,),
          image,
          SizedBox(height: betweenPadding,),
          Text(title, style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold,),),
          secondary == null ? Container() : SizedBox(height: 6,),
          secondary == null ? Container() : secondary!
        ],
      ),
    );
  }
}