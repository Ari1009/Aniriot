// ignore_for_file: unused_import

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../helpers/cache_manager.dart';
import '../models/anime.dart';
import '../theme/aniriot_theme.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({Key? key, required this.anime}) : super(key: key);
  final Anime anime;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.videoListScreen, arguments: {
          'anime': anime,
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black26,
        ),
        height: 160,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                key: UniqueKey(),
                cacheManager: CustomCacheManager.instance,
                width: 110.w,
                imageUrl: anime.imageUrl.toString(),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
                    child: Text(
                      anime.name.toString(),
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AniriotTheme.darkTextTheme.subtitle2!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
                    child: Text(
                      anime.releasedDate.toString(),
                      softWrap: true,
                      style: AniriotTheme.darkTextTheme.subtitle1!
                          .copyWith(color: Color.fromARGB(255, 233, 5, 39)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
