
import 'package:flutter/material.dart';
import 'package:custom_splash/custom_splash.dart';
import 'package:surakshaapp/templates/Login.dart';

class Splash extends StatelessWidget {
  //////////////////////base
  @override
  Widget build(BuildContext context) {

    return CustomSplash(
      imagePath: 'assets/Logo.png',
      backGroundColor: Color(0xfffaef03),
      //animationEffect: 'zoom-out',
      logoSize: 5000,
      home: Login(),
      //customFunction: duringSplash,
      duration: 2500,
      type: CustomSplashType.StaticDuration,
      //outputAndHome: op,
    );
  }

}

