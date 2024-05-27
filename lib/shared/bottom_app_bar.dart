import 'package:flutter/material.dart';
import 'package:french_words_learner/backend/learning_service.dart';
import 'package:french_words_learner/custom_icons_icons.dart';

class MyBottomAppBar extends StatefulWidget {

  final void Function(int) changeIndex;

  MyBottomAppBar(this.changeIndex);

  @override
  State<MyBottomAppBar> createState() => _MyBottomAppBarState();
}

class _MyBottomAppBarState extends State<MyBottomAppBar> {

  int index = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
      child: Container(
        padding: EdgeInsets.fromLTRB(80, 5, 80, 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Theme.of(context).colorScheme.primary,
          boxShadow: [
            BoxShadow(
              blurRadius: 15,
              spreadRadius: 5,
              //offset: Offset(0, 20),
              color: Theme.of(context).colorScheme.primary.withOpacity(0.4)
            )
          ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BottomAppBarItem(Icon(CustomIcons.flash_cards), () => changeIndex(0), selectedIndex: index == 0,),
            BottomAppBarItem(Icon(Icons.search), () => changeIndex(1), selectedIndex: index == 1,),
            BottomAppBarItem(Icon(Icons.settings), () => changeIndex(2), selectedIndex: index == 2,)
          ],
        ),
      ),
    );
  }
  
  void changeIndex(int i) {
    LearningService().printLocalstore();
    if(i == index)
      return;
    setState(() {
      index = i;
    });
    widget.changeIndex(i);
  }
}

class BottomAppBarItem extends StatefulWidget {

  final Widget icon;
  final Function()? onPressed;
  final bool selectedIndex;

  BottomAppBarItem(this.icon, this.onPressed, {this.selectedIndex = false});

  @override
  State<BottomAppBarItem> createState() => _BottomAppBarItemState();
}

class _BottomAppBarItemState extends State<BottomAppBarItem> with TickerProviderStateMixin {

  late final Animation<double> _animation;
  late final AnimationController _controller;

  @override void initState() {
    // TODO: implement initState
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this
    )..forward();

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastLinearToSlowEaseIn
    );
    super.initState();
  }

  @override
  void didUpdateWidget(covariant BottomAppBarItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex && !_controller.isAnimating) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: ScaleTransition(
              scale: _animation,
              child: Container(
                width: 40,
                height: 40,
                padding: EdgeInsets.all(5),
                decoration: widget.selectedIndex ? BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.25),
                  borderRadius: BorderRadius.all(Radius.circular(17)),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.onPrimary
                  )
                ) : null,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: IconButton(
                icon: widget.icon,
                onPressed: widget.onPressed
            ),
          ),
        ],
      ),
    );
  }
}