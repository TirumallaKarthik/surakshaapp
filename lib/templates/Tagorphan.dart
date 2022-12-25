
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:surakshaapp/templates/Builders.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:surakshaapp/DBObject.dart';
import 'package:surakshaapp/Scripts/Index.dart';


class Tagorphan extends StatelessWidget {


  ///////////////////////////////variables used
  late var height;
  late var width;
  late Ngoobject user;
  late List<Orphanobject> orphanlst;
  Index idx = new Index();
  TextEditingController id = new TextEditingController();


  //////////////////////base

  @override
  Widget build(BuildContext context) {

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    Map args = ModalRoute.of(context)!.settings.arguments as Map;
    user = args['user'];
    orphanlst = args['orphanslist'];

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(backgroundColor: Colors.black38, title:Text('Hi ${user.name}')),
        backgroundColor: Colors.white,
        body:
        Center(
            child:
         Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget> [
           Center( child:
                TextBuilder('TAG ORPHAN', 'JosefinSans', 45.0, FontWeight.bold, Colors.black).builder()
            ),
            Center( child:
                TextBuilder('ENTER THE ID TO TAG THE ORPHAN', 'JosefinSans', 15.0, FontWeight.bold, Colors.black).builder()
            ),
            Container(
                width: 250,
                child:
                TextInputBuilder(TextInputType.text, 'Id', 'Enter id', BorderRadius.circular(50), id).builder()
            ),
            ElevatedButton(
                child: Text('Tag Orphan'),
                onPressed: () async
                {
                  orphanlst.add(await idx.addorphan(user,id:id.text) as Orphanobject);
                  Navigator.pop(context);
                }
            ),
            SizedBox(height:height/8, width:width)

          ],
        )
        )
    );

  }



}


