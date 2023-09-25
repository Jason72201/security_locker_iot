import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:security_locker_iot/splash_screen_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle( SystemUiOverlayStyle(
    //   statusBarColor: Color(ColorHexCode.primaryBlue), // status bar color
    // ));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'SecurityLocker',
      theme: ThemeData(
        // appBarTheme: AppBarTheme(
        //   iconTheme: IconThemeData(
        //     color: Color(ColorHexCode.appIconTheme), //change your color here
        //   ),
        // ),
        primarySwatch: Colors.blueGrey,
        primaryColor: Colors.white,
        backgroundColor: Colors.white,
      ),
      home: const SplashScreenPage(),
    );
  }
}
