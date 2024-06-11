import 'package:flutter/material.dart';
import 'package:french_words_learner/onboarding_ui/onboarding_page.dart';

class Onboarding extends StatefulWidget {

  final void Function() goToHome;
  final void Function() onEndBoardingDone;

  const Onboarding(this.goToHome, this.onEndBoardingDone, {super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {

  int _currentIndex = 0;
  final PageController _pageCtrl = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageCtrl,
              children: pages,
              onPageChanged: (value) {
                setState(() {
                  _currentIndex = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: List.generate(pages.length, (index) => Padding(padding: EdgeInsets.all(2), child: StepIndicator(index == _currentIndex))),
                ),
                const Spacer(),
                IconButton.filled(
                  onPressed: (){
                    if(_currentIndex == pages.length - 1){ // end 
                      widget.goToHome();
                      widget.onEndBoardingDone();
                    }
                    else
                      _pageCtrl.nextPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
                  },
                  icon: Icon(_currentIndex == pages.length - 1 ? Icons.check : Icons.arrow_forward_outlined),
                  iconSize: 30,
                ),
              ],
            ),
          ),
          SizedBox(height: 35,)
        ],
      ),
    );
  }

  List<OnboardingPage> pages = [
    OnboardingPage(
      image: Image.asset("assets/images/onboarding/welcome-screen.gif"),
      title: "Bienvenue sur Maitre'mot !",
      secondary: Text("N'oubliez plus jamais les mots que vous rencontrez", style: TextStyle(fontSize: 14),),
      heightPadding: 130,
      betweenPadding: 130,
    ),
    OnboardingPage(
      image: Image.asset("assets/images/onboarding/idea-screen1.gif"),
      title: "Rencontrez un mot que vous ne connaissez pas",
      secondary: Text("Dans un livre, un article ou bien une discussion", style: TextStyle(fontSize: 14),),
    ),
    OnboardingPage(
      image: Image.asset("assets/images/onboarding/search-word.gif"),
      title: "Cherchez le",
      secondary: Text("Dans le dictionnaire intégré à l'application (pas besoin de connection Internet)", style: TextStyle(fontSize: 14),),
      heightPadding: 120,
      betweenPadding: 210,
    ),
    OnboardingPage(
      image: Image.asset("assets/images/onboarding/word-info.gif"),
      title: "Découvrez sa définition et ajoutez le à votre liste d'apprentissage",
      heightPadding: 110,
      betweenPadding: 200,
    ),
    OnboardingPage(
      image: Center(child: Image.asset("assets/images/onboarding/learn-screen.gif", scale: 2.3,)),
      title: "Revenez chaque jour pour continuer l'apprentissage ludique",
      secondary: Text("Grace à la méthode d'apprentissage sur la durée, mémorisez pour la vie", style: TextStyle(fontSize: 14),),
      betweenPadding: 40,
    ),
    OnboardingPage(
      image: Image.asset("assets/images/onboarding/settings-image.png"),
      title: "Parcourez l'onglet 'Parametres' pour plus de configuration !",
      heightPadding: 120,
      betweenPadding: 210,
    ),
  ];
}

class StepIndicator extends StatelessWidget {

  final bool isActive;

  StepIndicator(this.isActive);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8,
      width: isActive ? 35 : 8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.onPrimary.withOpacity(isActive ? 1 : 0.5),
      ),
    );
  }
}