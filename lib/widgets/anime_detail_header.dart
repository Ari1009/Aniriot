import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../models/anime.dart';
import '../theme/aniriot_theme.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import 'cache_image_with_cachemanager.dart';

class AnimeDetailHeader extends StatelessWidget {
  const AnimeDetailHeader({
    Key? key,
    required this.anime,
    required this.imageUrl,
    required this.name,
  }) : super(key: key);
  final Anime anime;
  final String name;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenHeight * .30,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 0.5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: NetworkImageWithCacheManager(
                imageUrl: imageUrl,
              ),
            ),
          ),
          SizedBox(
            width: 20.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 15.h),
                  child: Text(
                    name,
                    style: AniriotTheme.darkTextTheme.headline4!.copyWith(),
                  ),
                ),
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Text.rich(
                      TextSpan(children: [
                        TextSpan(
                            text: 'Released: ',
                            style: AniriotTheme.darkTextTheme.bodyText2),
                        TextSpan(
                            text: anime.releasedDate.toString(),
                            style: AniriotTheme.darkTextTheme.bodyText1),
                      ]),
                    )),
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Text.rich(
                      TextSpan(children: [
                        TextSpan(
                            text: 'Status: ',
                            style: AniriotTheme.darkTextTheme.bodyText2),
                        TextSpan(
                            text: anime.status.toString(),
                            style: AniriotTheme.darkTextTheme.bodyText1),
                      ]),
                    )),
                const SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: Wrap(
                    children: anime.genres!
                        .map((genre) => Transform(
                              transform: Matrix4.identity()..scale(0.8),
                              child: InkWell(
                                onTap: () {
                                  Get.toNamed(Routes.genreScreen,
                                      arguments: genre);
                                },
                                child: Chip(
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  label: Text(genre.name.toString()),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
