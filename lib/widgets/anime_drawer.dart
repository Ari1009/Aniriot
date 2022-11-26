// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helpers/webview_manager.dart';
import '../theme/aniriot_theme.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';

class AnimeDrawer extends StatelessWidget {
  const AnimeDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color(0xFF0D1321),
        child: ListView(
          children: [
            SizedBox(
              height: (screenHeight * .39).h,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.h),
                      child: Image.asset(
                        'assets/images/p1.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.black45,
                  ),
                  Positioned(
                    right: 5,
                    left: 5,
                    bottom: 0,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      height: (screenHeight * .07).h,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 233, 5, 39).withOpacity(.7),
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10))),
                      child: Text(
                        'Aniriot',
                        style: AniriotTheme.darkTextTheme.headline4,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: (screenHeight * .02).h,
            ),
            ListTile(
              onTap: () => Get.toNamed(Routes.aboutAppScreen),
              hoverColor: Colors.white,
              leading: const Icon(Icons.info),
              title: const Text('About Aniriot'),
            ),
            ListTile(
              onTap: () => Get.toNamed(Routes.genreSelectionScreen),
              hoverColor: Colors.white,
              leading: const Icon(Icons.list_outlined),
              title: const Text('Genres'),
            ),
            ListTile(
              onTap: () => Get.toNamed(Routes.settingsScreen),
              hoverColor: Colors.white,
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
