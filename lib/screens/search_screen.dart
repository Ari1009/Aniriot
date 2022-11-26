// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/anime.dart';
import '../services/anime_service.dart';
import '../services/request_service.dart';
import '../theme/aniriot_theme.dart';
import '../utils/aniriot_helper.dart';
import '../utils/constants.dart';
import '../widgets/aniriot_animation.dart';
import '../widgets/searched_result_anime_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  var hasValue = false.obs;
  var title = ''.obs;
  final TextEditingController _controller = TextEditingController();
  late AnimationController controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: Duration(milliseconds: takoAnimationDuration), vsync: this);
    _controller.addListener(() {
      if (_controller.text.length >= 4) {
        title.value = _controller.text;
        controller.reset();
        hasValue.value = true;
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final itemHeight = ((screenHeight - kToolbarHeight - 24) / 2).h;
    // final itemWidth = (screenWidth / 2).w;
    final provider = Provider.of<RequestService>(context);

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
          title: TextField(
            key: _formKey,
            controller: _controller,
            decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.clear,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _controller.clear();
                    hasValue.value = false;
                  },
                ),
                hintText: 'Search...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(20)),
            onSubmitted: (val) {
              _saveToRecentSearches(val);
              controller.reset();
              hasValue.value = true;
              title.value = val;
            },
          ),
        ),
        body: Obx(
          () => hasValue.value
              ? FutureBuilder<AnimeResults>(
                  future: AnimeService()
                      .getAnimes(provider.requestSearchResponse(title.value)),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'No Results Found !',
                          style: AniriotTheme.darkTextTheme.headline3,
                        ),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      final list = snapshot.data!.animeList;

                      return GridView.builder(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 20.h),
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          childAspectRatio: .53,
                          crossAxisSpacing: 30,
                          mainAxisSpacing: 40,
                          maxCrossAxisExtent: 220,
                        ),
                        itemCount: list!.length,
                        itemBuilder: (BuildContext context, int index) {
                          controller.forward();
                          return AnimatedBuilder(
                            animation: controller,
                            child: SearchedResultAnimeCard(
                              anime: list[index],
                            ),
                            builder: (BuildContext context, Widget? child) {
                              return Transform(
                                transform: Matrix4.translationValues(
                                    0,
                                    100 *
                                        (1.0 -
                                            AniriotCurveAnimation(controller, index,
                                                    list.length)
                                                .value),
                                    0),
                                child: child,
                              );
                            },
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: loadingIndicator,
                      );
                    }
                  })
              : FutureBuilder<List<String>>(
                  future: _getRecentSearches(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      final searches = snapshot.data;
                      if (searches!.isNotEmpty) {
                        return ListView.builder(
                            itemCount: searches.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                  key: Key(index.toString()),
                                  onTap: () {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    setState(() {
                                      title.value = searches[index];
                                      _controller.text = title.value;
                                      hasValue.value = true;
                                    });
                                  },
                                  title: Text(searches[index]),
                                  trailing: IconButton(
                                      onPressed: () {
                                        _deleteSearch(searches[index]);
                                        setState(() {});
                                      },
                                      icon: const Icon(
                                        Icons.delete_rounded,
                                        color: Color.fromARGB(255, 233, 5, 39),
                                      )));
                            });
                      }
                    }
                    return const SizedBox();
                  }),
        ));
  }

  Future<void> _saveToRecentSearches(searchText) async {
    if (searchText != null) {
      final pref = await SharedPreferences.getInstance();
      Set<String> allSearches =
          pref.getStringList('takoRecentSearches')?.toSet() ?? {};

      allSearches = {searchText, ...allSearches};
      await pref.setStringList('takoRecentSearches', allSearches.toList());
    }
  }

  Future<void> _deleteSearch(searchText) async {
    final pref = await SharedPreferences.getInstance();
    final newList = pref
        .getStringList('takoRecentSearches')!
        .where((result) => result != searchText)
        .toList();
    await pref.setStringList('takoRecentSearches', newList);
  }

  Future<List<String>> _getRecentSearches() async {
    final pref = await SharedPreferences.getInstance();
    final allSearches = pref.getStringList('takoRecentSearches');
    if (allSearches != null) {
      return allSearches.toList();
    }
    return [];
  }
}
