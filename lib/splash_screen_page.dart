import 'package:flutter/material.dart';
import 'package:security_locker_iot/homapage.dart';

// import 'package:fyp_book_recommendations_application/_home_page.dart';
// import 'package:fyp_book_recommendations_application/_login_page.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);
  @override
  State<SplashScreenPage> createState() => _SplashScreenPage();
}

class _SplashScreenPage extends State<SplashScreenPage> {
  @override
  Widget build(BuildContext context) {
    var heightOfScreen = MediaQuery.of(context).size.height;
    var widthOfScreen = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.blueGrey,
        body: Container(
            height: heightOfScreen,
            width: widthOfScreen,
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: heightOfScreen / 2,
                    child: Image.asset(
                      'assets/securityLockerIcon.png',
                    )),
                const Text(
                  'Security Locker',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                )
              ],
            )));
  }

  @override
  initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      _goToMainPage(context);
      // String? accessToken;

      // GeneralUtils.getTokenSharedPreferences().then((result) {
      //   accessToken = result;
      //   if (accessToken == null) {
      //     _goToLoginPage(context);
      //   } else {
      //     _goToMainPage(context);
      //   }
      // });
    });
  }

  void _goToMainPage(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
      (Route<dynamic> route) => false,
    );
  }

  // void _goToLoginPage(BuildContext context) {
  //   Navigator.pushAndRemoveUntil(
  //     context,
  //     MaterialPageRoute(builder: (context) => const LoginPage()),
  //     (Route<dynamic> route) => false,
  //   );

  // GeneralUtils.showToast("Please login to use our apps..");
  // }
}
