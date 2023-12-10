import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import "package:flutter/material.dart";
import 'package:get_storage/get_storage.dart';
import 'package:new_sdk_demo/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        builder: (_, child) {
          return GetMaterialApp(
            title: 'E Bus TravelMate',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: const Color(0xff4C53FB),
            ),
            home: SplashScreen(),
          );
        });
  }
}
