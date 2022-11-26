// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../models/anime.dart';
import '../services/anime_service.dart';
import '../services/request_service.dart';
import '../theme/aniriot_theme.dart';
import '../utils/aniriot_helper.dart';
import '../utils/constants.dart';
import '../widgets/aniriot_animation.dart';
import '../widgets/aniriot_scaffold.dart';
import '../widgets/searched_result_anime_card.dart';

class GenreScreen extends StatefulWidget {
  const GenreScreen({Key? key}) : super(key: key);

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen>
    with SingleTickerProviderStateMixin {
  int _pageIndex = 1;
  bool hasNoMoreResult = false;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: Duration(milliseconds: takoAnimationDuration), vsync: this);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RequestService>(context);
    final Genre genre = Get.arguments;

    return AniriotScaffoldWithBackButton(
      appBarTitle: genre.name,
      body: Column(
        children: [
          Expanded(
              child: FutureBuilder<AnimeResults>(
                  future: AnimeService().getAnimes(
                      provider.requestAnimeGenre(genre.link, _pageIndex)),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      hasNoMoreResult = true;
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
                          animationController.forward();
                          return AnimatedBuilder(
                            animation: animationController,
                            child: SearchedResultAnimeCard(
                              anime: list[index],
                            ),
                            builder: (BuildContext context, Widget? child) {
                              return Transform(
                                transform: Matrix4.translationValues(
                                    0,
                                    100 *
                                        (1.0 -
                                            AniriotCurveAnimation(
                                                    animationController,
                                                    index,
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
                  })),
          Align(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              decoration: BoxDecoration(
                color: Color(0xFF0D1321),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                      onTap: () {
                        if (_pageIndex != 1 && _pageIndex > 1) {
                          _pageIndex--;
                          animationController.reset();
                          setState(() {});
                        }
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                        decoration: BoxDecoration(
                            // color: Color.fromARGB(255, 233, 5, 39),
                            borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        )),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.arrow_back_ios_new_rounded,
                            ),
                            Text('Prev'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Text(
                      _pageIndex.toString(),
                      style: AniriotTheme.darkTextTheme.headline3!.copyWith(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      onTap: () {
                        if (!hasNoMoreResult) {
                          _pageIndex++;
                          animationController.reset();
                          setState(() {});
                        }
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                        decoration: BoxDecoration(
                            // color: Color.fromARGB(255, 233, 5, 39),
                            borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        )),
                        child: Row(
                          children: const [
                            Text('Next'),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
