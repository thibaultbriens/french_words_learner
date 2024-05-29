import 'package:flutter/material.dart';
import 'package:french_words_learner/backend/search_service.dart';
import 'package:french_words_learner/screens/search/word_info.dart';
import 'package:french_words_learner/shared/loader.dart';
import 'package:french_words_learner/shared/word.dart';

class Search extends StatefulWidget {
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchCtrl = TextEditingController();

  List<String> searchList = [];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          delegate: _SliverAppBarDelegate(
            minHeight: 20 + 10 + 45,
            maxHeight: 20 + 10 + 45,
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                child: Container(
                  height: 45,
                  child: SearchBar(
                    controller: _searchCtrl,
                    hintText: "Tapez un mot",
                    hintStyle: MaterialStateTextStyle.resolveWith(
                        (states) => TextStyle(color: Colors.black.withOpacity(0.4))),
                    elevation: MaterialStateProperty.resolveWith((states) => 3),
                    backgroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
                    trailing: [
                      IconButton(
                          onPressed: () { _searchCtrl.clear(); setState(() => searchList = []);},
                          icon: Icon(Icons.clear))
                    ],
                    leading: IconButton(
                      onPressed: () => searchWord(),
                      icon: Icon(Icons.search)
                    ),
                    onSubmitted: (value) async {
                      // Update searchList
                      print("submitted");
                      searchWord();
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: StatefulBuilder(
            builder: (context, setState2) {
              /*void _searchCtrlListener() {
                print(_searchCtrl.text);
                setState2(() {
                  // Update searchList
                  searchWord();
                });
              }

              _searchCtrl.addListener(_searchCtrlListener);*/

              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: searchList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(searchList[index]),
                    onTap: ()  async {
                      Word wordObj = await SearchService().wordNameToObject(searchList[index]);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder:
                          (context) => WordInfo(wordObj)
                        ),
                      );
                    }
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void searchWord() async{
    searchList = await SearchService().nextWords(_searchCtrl.text);
    setState(() {});
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
