import 'package:flutter/material.dart';
import 'package:french_words_learner/backend/search_service.dart';
import 'package:french_words_learner/screens/search/word_info.dart';
import 'package:french_words_learner/shared/loader.dart';
import 'package:french_words_learner/shared/word.dart';

class Search extends StatelessWidget {
  final TextEditingController _searchCtrl = TextEditingController();

  List<String> searchList = [];
  late List<String> allWords;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: SearchService().allWords,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loader();
        }

        if (snapshot.hasError) {
          print(snapshot.error);
          return Text("Snapshot error: ${snapshot.error}");
        }

        allWords = snapshot.data!;
        searchList = allWords;
        

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
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
                          onPressed: () => _searchCtrl.clear(),
                          icon: Icon(Icons.clear))
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: StatefulBuilder(
                builder: (context, setState2) {
                  void _searchCtrlListener() {
                    print(_searchCtrl.text);
                    setState2(() {
                      // Update searchList
                      searchList = allWords
                          .where((element) => element.contains(_searchCtrl.text.trim()))
                          .toList();
                    });
                  }

                  _searchCtrl.addListener(_searchCtrlListener);

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
      },
    );
  }
}
