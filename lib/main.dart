import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gyalcuser_project/constants/colors.dart';
import 'package:gyalcuser_project/providers/multi_provider.dart';
import 'package:gyalcuser_project/screens/splashscreen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await LocalNotificationsService.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: orange));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ScreenUtilInit(
        designSize: const Size(1080, 2280),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: () {
          return MultiProvider(
              providers: multiProvider,
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'gyalcproject',
                theme: ThemeData(
                  primarySwatch: Colors.yellow,
                ),
                home: const Splash(),
              ));
        });
  }
}
