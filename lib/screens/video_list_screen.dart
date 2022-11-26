import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../helpers/bookmark_manager.dart';
import '../helpers/recent_watch_manager.dart';
import '../models/anime.dart';
import '../models/bookmark.dart';
import '../models/recent_anime.dart';
import '../services/anime_service.dart';
import '../theme/aniriot_theme.dart';
import '../utils/aniriot_helper.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import '../widgets/anime_detail_header.dart';
import '../widgets/aniriot_animation.dart';
import '../widgets/aniriot_scaffold.dart';
import '../widgets/cache_image_with_cachemanager.dart';
import '../widgets/plot_summary.dart';

class VideoListScreen extends StatefulWidget {
  const VideoListScreen({Key? key}) : super(key: key);

  @override
  _VideoListScreenState createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen>
    with SingleTickerProviderStateMixin {
  final RecentWatchManager recentWatchManager = Get.find();
  final BookMarkManager bookMarkManager = Get.find();
  var selectedIndex = 9999999.obs;
  var isExpanded = false.obs;
  final name = Get.arguments['anime'].name.toString();
  final imageUrl = Get.arguments['anime'].imageUrl.toString();
  final animeUrl = Get.arguments['anime'].animeUrl.toString();
  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  bool hasRemainingEp = false;
  int remainingEp = 0;
  int totalChipCount = 0;
  RxList<Episode> epChunkList = <Episode>[].obs;
  String start = '';
  String end = '';
  int finalChipCount = 0;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: Duration(milliseconds: takoAnimationDuration), vsync: this);
    fadeAnimation =
        Tween<double>(begin: 0, end: 1).animate(animationController);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: Get.arguments['anime'].id.toString(),
      child: AniriotScaffoldWithBackButton(
        appBarTitle: 'Aniriot',
        body: FutureBuilder<Anime>(
            future: AnimeService().fetchAnimeDetails(animeUrl),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'An Error ccurred',
                    style: AniriotTheme.darkTextTheme.headline3,
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                final anime = snapshot.data;
                if ((anime!.episodes!.length % 50).floor() < 50) {
                  hasRemainingEp = true;
                  remainingEp = (anime.episodes!.length % 50).floor();
                }
                totalChipCount = (anime.episodes!.length / 50).floor();
                epChunkList.value = anime.episodes!.sublist(
                    0,
                    (hasRemainingEp == true && anime.episodes!.length < 50)
                        ? remainingEp
                        : 50);
                finalChipCount = totalChipCount + (hasRemainingEp ? 1 : 0);

                print('Ep Chunk List ${epChunkList.length}+ $remainingEp');
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: NetworkImageWithCacheManager(
                        imageUrl: imageUrl,
                      ),
                    ),
                    BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 8,
                        sigmaY: 8,
                      ),
                      child: Container(
                        color: Colors.black87,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                    Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: ListView(
                            children: [
                              AnimeDetailHeader(
                                anime: anime,
                                name: name,
                                imageUrl: imageUrl,
                              ),
                              SizedBox(
                                height: 40.h,
                              ),
                              PlotSummary(
                                summary: anime.summary.toString(),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  top: 40.h,
                                  left: 10.w,
                                  right: 10.w,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Episodes',
                                      style: AniriotTheme.darkTextTheme.headline5,
                                    ),
                                    GetBuilder<BookMarkManager>(
                                      builder: (_) => TextButton.icon(
                                          onPressed: () {
                                            final item = BookMark(
                                              id: anime.id!,
                                              imageUrl: imageUrl,
                                              name: name,
                                              animeUrl: animeUrl,
                                            );
                                            if (bookMarkManager.ids.contains(
                                                anime.id.toString())) {
                                              bookMarkManager
                                                  .removeFromBookMarks(item);
                                              //Removed
                                              Get.snackbar(name,
                                                  'Removed from bookmark successfully!',
                                                  backgroundColor:
                                                      Colors.black38,
                                                  duration: const Duration(
                                                      milliseconds: 1300),
                                                  snackPosition:
                                                      SnackPosition.BOTTOM);
                                            } else {
                                              bookMarkManager
                                                  .addToBookMarks(item);
                                              //Add
                                              Get.snackbar(name,
                                                  'Added to bookmark successfully!',
                                                  backgroundColor:
                                                      Colors.black38,
                                                  duration: const Duration(
                                                      milliseconds: 1300),
                                                  snackPosition:
                                                      SnackPosition.BOTTOM);
                                            }
                                          },
                                          icon: Icon(
                                            bookMarkManager.ids
                                                    .contains(anime.id)
                                                ? Icons.bookmark
                                                : Icons
                                                    .bookmark_border_outlined,
                                            color: Color.fromARGB(255, 233, 5, 39),
                                          ),
                                          label: Text(
                                            'BookMark',
                                            style: AniriotTheme
                                                .darkTextTheme.bodyText1!
                                                .copyWith(color: Color.fromARGB(255, 233, 5, 39)),
                                          )),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 5),
                                child: const Divider(),
                              ),
                              anime.episodes!.length > 50
                                  ? SizedBox(
                                      height: 70,
                                      child: ListView.builder(
                                        itemCount: finalChipCount,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InkWell(
                                              onTap: () {
                                                animationController.reset();
                                                getEpisodeRange(index);
                                                if (finalChipCount ==
                                                    (index + 1)) {
                                                  takoDebugPrint('last chip');
                                                  epChunkList.value =
                                                      anime.episodes!.sublist(
                                                    int.parse(start) - 1,
                                                  );
                                                } else {
                                                  epChunkList.value =
                                                      anime.episodes!.sublist(
                                                          int.parse(start) - 1,
                                                          int.parse(end));
                                                }
                                              },
                                              child: Chip(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                label: Text(
                                                  getEpisodeRange(index),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        scrollDirection: Axis.horizontal,
                                      ))
                                  : SizedBox(),
                              // Episodes Grid View
                              anime.episodes!.isNotEmpty
                                  ? Obx(
                                      () => GridView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        gridDelegate:
                                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                          mainAxisSpacing: 20,
                                          crossAxisSpacing: 20,
                                          maxCrossAxisExtent: 50,
                                        ),
                                        itemCount: epChunkList.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          animationController.forward();
                                          return Obx(
                                            () => AnimatedBuilder(
                                              animation: animationController,
                                              child: Material(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color:
                                                    selectedIndex.value == index
                                                        ? Color.fromARGB(
                                                            255, 50, 55, 66)
                                                        : Color.fromARGB(255, 233, 5, 39)
                                                            .withAlpha(200),
                                                child: InkWell(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  onTap: () async {
                                                    selectedIndex.value = index;
                                                    final recentAnime =
                                                        RecentAnime(
                                                      id: anime.id.toString(),
                                                      name: name,
                                                      currentEp:
                                                          'Episode ${epChunkList[index].number}',
                                                      imageUrl: imageUrl,
                                                      epUrl: epChunkList[index]
                                                          .link
                                                          .toString(),
                                                      // animeUrl: animeUrl,
                                                    );
                                                    // Add to Recent Anime List
                                                    recentWatchManager
                                                        .addAnimeToRecent(
                                                            recentAnime);
                                                    await Get.toNamed(
                                                        Routes.mediaFetchScreen,
                                                        arguments: {
                                                          'animeUrl':
                                                              epChunkList[index]
                                                                  .link
                                                                  .toString()
                                                        });
                                                  },
                                                  splashColor: Colors.white,
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        boxShadow: const [
                                                          BoxShadow(
                                                            color:
                                                                Colors.black12,
                                                            spreadRadius: 2,
                                                            blurRadius: 7,
                                                            offset:
                                                                Offset(0, 5),
                                                          ),
                                                        ],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: Text(
                                                      epChunkList[index].number,
                                                      style: AniriotTheme
                                                          .darkTextTheme
                                                          .headline6,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              builder: (context, child) {
                                                return Transform(
                                                  transform: Matrix4.translationValues(
                                                      0,
                                                      100 *
                                                          (1.0 -
                                                              AniriotCurveAnimation(
                                                                      animationController,
                                                                      index,
                                                                      epChunkList
                                                                          .length)
                                                                  .value),
                                                      0),
                                                  child: child,
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Text(
                                        'Coming Soon ..',
                                        style:
                                            AniriotTheme.darkTextTheme.subtitle2,
                                      ),
                                    ),
                            ],
                          ),
                        )),
                  ],
                );
              } else {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      bottom: 0,
                      right: 0,
                      child: NetworkImageWithCacheManager(
                        imageUrl: imageUrl,
                      ),
                    ),
                    BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 8,
                        sigmaY: 8,
                      ),
                      child: Container(
                        color: Colors.black87,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ],
                );
              }
            }),
      ),
    );
  }

  String getEpisodeRange(int index) {
    start = ((index * 50) + 1).toString();
    end = ((50 * (index + 1))).toString();
    if (index == totalChipCount && hasRemainingEp) {
      end = ((50 * index) + remainingEp).toString();
    }
    // startVal = start;
    // endVal = (int.parse(end) + 1).toString();
    return ('$start - $end');
  }
}
