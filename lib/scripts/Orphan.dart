
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Widgets.dart';

class Orphanprofile extends StatelessWidget {


  ///////////////////////////////variables used
  var height;
  var width;
  var id;
  var name;
  var age;
  var coordinates;
  var adoptedby;
  var imageurl;
  //////////////////////////////functions
  Future<Widget> getdata() async{


    await FirebaseFirestore.instance.collection('orphans').doc(id).get().then(
            (document) async
        {
          if(!document.exists) {
            name = document.data()!['childname'];
            age = document.data()!['age'];
            coordinates = document.data()!['coordinates'];
            adoptedby = document.data()!['adoptedby'];
            imageurl = document.data()!['imageurl'];
          }
        });



    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(backgroundColor: Colors.black38, title:Text('Orphan Profile')),
        backgroundColor: Colors.white,
        body:
        Center(
            child:
            Column(
                children:[
                  Expanded( child: Stack(
                      alignment: AlignmentDirectional.center,
                      children:[
                        Image( image: AssetImage('assets/back.png'),height: height/4),
                        Positioned( child:Text(name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)), top:height/3.5),
                        Positioned(child:Container(child: Image.network(imageurl.toString()),height: height/4,width: width/4),top:height/18)
                      ]
                  )),
                  SizedBox(
                    height: 15,
                  ),
                  Center( child:Stack(
                      alignment: AlignmentDirectional.center,
                      children:[
                        Container( child:Image( image: AssetImage('assets/back_bo.png')),height: height/8, width: 9*width/10),
                        Text(name+'  '+age, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white))
                      ]
                  )),
                  SizedBox(
                    height: 15,
                  ),
                  Center( child:Stack(
                      alignment: AlignmentDirectional.center,
                      children:[
                        Container( child:Image( image: AssetImage('assets/back_bo.png')),height: height/8, width: 9*width/10),
                        Text(coordinates, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white))
                      ]
                  )),
                  SizedBox(
                    height: 15,
                  ),
                  Center( child: Stack(
                      alignment: AlignmentDirectional.center,
                      children:[
                        Container( child:Image( image: AssetImage('assets/back_bo.png')),height: height/8, width: 9*width/10),
                        Text(adoptedby, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white))
                      ]
                  )),
                  SizedBox(
                    height: 40,
                  )
                ]

            )
        )
    );
  }

  //////////////////////base

  @override
  Widget build(BuildContext context) {

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    Map args = ModalRoute.of(context)!.settings.arguments as Map;
    id = args['id'];

    return Container(
        child:
        FutureBuilder<dynamic>(
            builder: (context, snapshot){
              if(snapshot.hasData)
              { return snapshot.data;}

              return Center(child: CircularProgressIndicator());
            },
            future: getdata()
        )
    );

  }



}


