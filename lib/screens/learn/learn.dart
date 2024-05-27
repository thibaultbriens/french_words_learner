import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
// import 'package:swipe_cards/swipe_cards.dart';
// import 'package:swipeable_card_stack/swipeable_card_stack.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flip_card/flip_card.dart';
import 'package:french_words_learner/backend/learning_service.dart';
import 'package:french_words_learner/screens/learn/success_learn.dart';
import 'package:french_words_learner/screens/search/word_info.dart';
import 'package:french_words_learner/shared/loader.dart';
import 'package:french_words_learner/shared/word.dart';

class Learn extends StatefulWidget {
  const Learn({super.key});

  @override
  State<Learn> createState() => _LearnState();
}

class _LearnState extends State<Learn> {

  // constants
  /*List<Map<String, String>> words = [
    {"word": "Truand", "definition": "Un truand est un djkfhsd"},
    {"word": "Dromadaire", "definition": "Un dromadaire est un djkfhsd"},
    {"word": "Test", "definition": "Un test est un djkfhsd"},
    {"word": "Ordinateur", "definition": "Un ordinateur est un djkfhsd"},
    {"word": "Souris", "definition": "Un souris est un djkfhsd"}
  ];*/
  CardSwiperController _cardCtrl = CardSwiperController();
  FlipCardController _flipCardCtrl = FlipCardController();


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Word>>(
      future: LearningService().wordsToLearnToday,
      builder: (context, snapshot) {

        if(snapshot.connectionState == ConnectionState.waiting){
          return Loader();
        }
        if(snapshot.hasError){
          return Text("Snapshot error: ${snapshot.error}");
        }

        // snapshot is good
        List<Word> words = snapshot.data!;

        if(words.isEmpty){
          return SuccessLearn();
        }

        return ExtractedWidget(words, _cardCtrl, _flipCardCtrl);
      }
    );
  }
}

class MyCard extends StatelessWidget {

  final Widget child;
  final FlipCardController flipCardController;

  const MyCard(this.child, this.flipCardController);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 370,
      height: 480,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            spreadRadius: 1,
            color: Colors.black.withOpacity(0.25)
          )
        ]
      ),
    
      child: Stack(
        children: [
          Center(child: child),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.flip_camera_android_outlined, size: 22,),
                onPressed: (){
                  flipCardController.toggleCard();
                },
              ),
            ),
          )
        ],
      ),
      
    );
  }
}

class ExtractedWidget extends StatefulWidget {

  final List<Word> words;
  final CardSwiperController cardCtrl;
  final FlipCardController flipCardCtrl;


  ExtractedWidget(this.words, this.cardCtrl, this.flipCardCtrl);

  @override
  State<ExtractedWidget> createState() => _ExtractedWidgetState(words, cardCtrl, flipCardCtrl);
}

class _ExtractedWidgetState extends State<ExtractedWidget> {
  List<Word> words;
  final CardSwiperController cardCtrl;
  final FlipCardController flipCardCtrl;

  _ExtractedWidgetState(this.words, this.cardCtrl, this.flipCardCtrl);

  List<Word> rightSwipes = [];
  List<Word> leftSwipes = [];

  @override
  Widget build(BuildContext context) {
    return words.isEmpty 
      ? SuccessLearn()
      : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                width: 370,
                height: 480,
                child: CardSwiper(
                  padding: EdgeInsets.zero,
                  numberOfCardsDisplayed: words.length < 3 ? words.length : 3,
                  controller: cardCtrl,
                  allowedSwipeDirection: AllowedSwipeDirection.symmetric(horizontal: true),
                  cardsCount: words.length,
                  cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
                    return FlipCard(
                      controller: flipCardCtrl,
                      speed: 400,
                      front: MyCard(Text(words[index].word), flipCardCtrl),
                      back: MyCard(
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 370,
                                height: 360,
                                child: words[index].buildWordInfo()
                              ),
                              TextButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => WordInfo(words[index]))), child: Text("See more"))
                            ],
                          ),
                        ),
                        flipCardCtrl
                      )
                    );
                  },
                  onSwipe: (previousIndex, currentIndex, direction) {

                    // add word to leftSwipes or rightSwipes
                    if(direction == CardSwiperDirection.right){
                      rightSwipes.add(words[previousIndex]);
                    }
                    else if(direction == CardSwiperDirection.left){
                      leftSwipes.add(words[previousIndex]);
                    }

                    // put the card to the front side back
                    if(!flipCardCtrl.state!.isFront){
                      flipCardCtrl.toggleCardWithoutAnimation();
                    } 
        
                    return true;
                  },
                  onUndo: (previousIndex, currentIndex, direction) {
                    // removce word from leftSwipes or rightSwipes
                    if(direction == CardSwiperDirection.right){
                      rightSwipes.remove(words[currentIndex]);
                    }
                    else if(direction == CardSwiperDirection.left){
                      leftSwipes.remove(words[currentIndex]);
                    }

                    return true;
                  },
                  isLoop: false,
                  onEnd: () {
                    print("Right swipes = ${rightSwipes.map((e) => e.word).toList()}\nLeft swipes = ${leftSwipes.map((e) => e.word).toList()}");
                    LearningService().updateWords(rightSwipes, leftSwipes);
                    setState(() {words = [];});
                  },
                ),
              ),
            ),
        
            // action buttons 
            SizedBox(height: 70,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  style: IconButton.styleFrom(
                    splashFactory: NoSplash.splashFactory
                  ),
                  padding: EdgeInsets.zero,
                  onPressed: (){
                    cardCtrl.swipe(CardSwiperDirection.left);
                  },
                  icon: Icon(Icons.cancel_outlined, color: Color.fromARGB(255, 255, 129, 129), size: 50,)
                ),
                SizedBox(width: 80,),
                IconButton(
                  style: IconButton.styleFrom(
                    splashFactory: NoSplash.splashFactory
                  ),
                  padding: EdgeInsets.zero,
                  onPressed: (){
                    setState(() {
                      cardCtrl.undo();
                    });
                  },
                  icon: Icon(Icons.replay, size: 50,)
                ),
                SizedBox(width: 80,),
                IconButton(
                  style: IconButton.styleFrom(
                    splashFactory: NoSplash.splashFactory
                  ),
                  padding: EdgeInsets.zero,
                  onPressed: (){
                    cardCtrl.swipe(CardSwiperDirection.right);
                  },
                  icon: Icon(Icons.check_circle_outline, color: Color.fromARGB(255, 129, 255, 133), size: 50,)
                ),
              ],
            ),
          ],
        );
  }
}