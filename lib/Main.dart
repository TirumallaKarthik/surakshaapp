
import 'package:flutter/material.dart';
import 'package:surakshaapp/templates/Login.dart';
import 'package:surakshaapp/templates/Memberentry.dart';
import 'package:surakshaapp/templates/New.dart';
import 'package:surakshaapp/templates/Ngoentry.dart';
import 'package:surakshaapp/templates/Addorphan.dart';
import 'package:surakshaapp/templates/Tagorphan.dart';
import 'package:surakshaapp/templates/Orphan.dart';
import 'package:surakshaapp/Splash.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async{
  /*
  This funciton is used to start the application
  */

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //FirebaseAuth.instance.signInAnonymously().then((result){print('signed in as ${result.user}');});

  runApp(
      MaterialApp(
          initialRoute: '/',
          routes: {
           'Login':(context)=>Login(), //Login activity functions later
           'Memberentry':(context)=>Memberentry(), //Member Landing activity check complete
           'Ngoentry':(context)=>Ngoentry(), //Ngo Landing activity check complete
           'AddOrphan':(context)=>Addorphan(), //Adding new Orphan activity check complete
           'TagOrphan':(context)=>Tagorphan(), //Tagging new Orphan activity check complete
           'Orphan':(context)=>Orphanprofile(), //Orphan activity check complete
            'New':(context)=>New(), //New User activity
          },
          debugShowCheckedModeBanner: false,
          home: Splash() //Splash screen check complete
      )
  );
}

