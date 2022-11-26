import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import '../bindings/managers_binding.dart';
import '../services/request_service.dart';
import 'theme/aniriot_theme.dart';
import 'utils/aniriot_route.dart';

Future<void> main() async {
  _configureApp();
  _setUpLogging();
  runApp(const MyApp());
}

void _configureApp() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
}

void _setUpLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((rec) {
    // ignore: avoid_print
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => RequestService.create(),
          dispose: (_, RequestService service) => service.client.dispose(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 764),
        builder: () => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Aniriot',
          theme:AniriotTheme.dark(),
          initialRoute: '/',
          initialBinding: ManagerBinding(),
          getPages: AniriotRoute.pages,
        ),
      ),
    );
  }
}
