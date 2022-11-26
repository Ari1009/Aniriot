import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/constants.dart';
import '../widgets/aniriot_scaffold.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AniriotScaffoldWithBackButton(
      appBarTitle: 'About',
      body: ListView(
        children: [
          const ListTile(
            title: Text('Version'),
            subtitle: Text(version),
          ),
          const ListTile(
            title: Text('Developer'),
            subtitle: Text('Arihant Pal'),
          ),
          ListTile(
            onTap: () => launch(aniriot),
            title: const Text('Source Code'),
            subtitle: const Text(aniriot),
          ),
          const ListTile(
            title: Text('License'),
            subtitle: Text(license),
          ),
          ListTile(
            title: const Text('What\'s the update ?'),
            onTap: () {
              Get.dialog(const AlertDialog(
                backgroundColor: Color(0xFF0D1321),
                content: Text(
                    '(-) Ui Changes in Recently Added Anime List.\n\n(-) Fixed Duplicate Recently Watched Anime.'),
              ));
            },
          ),
          ListTile(
            onTap: () => launch(mailing),
            title: const Text('Contact Developer'),
          ),
        ],
      ),
    );
  }
}
