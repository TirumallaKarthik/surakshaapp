
import 'package:flutter/material.dart';
import 'package:surakshaapp/templates/Login.dart';
import 'package:splashscreen/splashscreen.dart';


class Splash extends StatelessWidget {
  //////////////////////base
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 2,
      navigateAfterSeconds: Login(),
      image: Image.asset('assets/Logo.png'),
      photoSize: 100.0,
      loaderColor: Colors.red,

    );
    // return CustomSplash(
    //   imagePath: 'assets/Logo.png',
    //   backGroundColor: Color(0xfffaef03),
    //   logoSize: 5000,
    //   home: Login(),
    //   duration: 2500,
    //   type: CustomSplashType.StaticDuration,
    // );
  }

}

