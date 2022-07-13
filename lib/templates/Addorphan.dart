

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:surakshaapp/DOB.dart';

class Addorphan extends StatefulWidget {

  @override
  _entryState createState() => _entryState();
}

class _entryState extends State<Addorphan> {

  ///////////////////////////////variables used
  var height;
  var imageUrl = "https://picsum.photos/200";
  var width;
  var flag1 = false;
  var flag2 = false;
  var mobno;
  UserObject _mem = UserObject();
  var coordinates = "20E 30N";
  TextEditingController name = new TextEditingController();
  TextEditingController description = new TextEditingController();
  TextEditingController age = new TextEditingController();

  //////////////////////////////functions
  /*
  addlocation() async
  {
    var position = await GeolocatorPlatform.instance
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    var lat = position.latitude;
    var lon = position.longitude;
    coordinates = 'latitude: $lat longitude: $lon';
    setState(() {
      flag1==0;
    });
  }

  addimage() async
  {
    final _firebaseStorage = FirebaseStorage.instance;

    final picker = ImagePicker();
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
//    var img = await ImagePicker.pickImage(source: ImageSource.camera);
      final img = await picker.getImage(source: ImageSource.camera);
      var ipath = img.path;

      if (img != null) {
        print('image is not null');
        var snapshot = await _firebaseStorage.ref()
            .child('images/'+name.text)
            .putFile(File(ipath)).onComplete;
        print('snapshot done');
        var downloadUrl = await snapshot.ref.getDownloadURL();
        print('download url $downloadUrl');
        setState(() {
          imageUrl = downloadUrl;
          flag2=0;
          print('state is set');
        });
      }
    }
  }

  Future<void> uploadtofirestore(BuildContext context)
  async {
    await Firestore.instance.collection('users').document(mobno).get().then(
            (document) async
        {
          var children = document.data['orphans'];
          children.add({name.text+','+age.text:'not yet'});
          print('checkng if document exists');
          if(document.exists)
          {
            await Firestore.instance.collection('users').document(mobno).setData(
                {
                  'orphans_rep':document.data['orphans_rep']+1,
                  'orphans':children
                });

            await Firestore.instance.collection('orphans').document(name.text+','+age.text).setData(
                {
                  'childname':name.text,
                  'age':age.text,
                  'description':description.text,
                  'imageurl':imageUrl,
                  'coordinates': coordinates,
                  'adoptedby': 'not yet',
                  'reportedby': mobno
                });
          }
        }
    );

    print('going to mail');
    mailtongos(context);
  }

  mailtongos(context) async
  {
    String k = name.text+','+age.text;
    final QuerySnapshot result = await Firestore.instance.collection('ngos').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    print('got the documents');
    documents.forEach((data) async {
      final MailOptions mailOptions = MailOptions(
        body: 'Hi, here is an new orphan to be tagged id:'+k,
        subject: 'Orphan needs to be tagged',
        recipients: [data.documentID],
        isHTML: true,
        bccRecipients: [],
        ccRecipients: [],
        attachments: [],
      );
      String platformResponse;
      final MailerResponse response = await FlutterMailer.send(mailOptions);
      switch (response) {
        case MailerResponse.saved: /// ios only
          platformResponse = 'mail was saved to draft';
          break;
        case MailerResponse.sent: /// ios only
          platformResponse = 'mail was sent';
          break;
        case MailerResponse.cancelled: /// ios only
          platformResponse = 'mail was cancelled';
          break;
        case MailerResponse.android:
          platformResponse = 'intent was successful';
          break;
        default:
          platformResponse = 'unknown';
          break;
      }
      print('here is the response'+platformResponse);
    });
    Navigator.pop(context);
  }
  */
  //////////////////////base

  @override
  Widget build(BuildContext context) {

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    mobno = _mem.phonenumber;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(backgroundColor: Colors.black38, title:Text('Suraksha Member '+_mem.name)),
        backgroundColor: Colors.white,
        body:
        ListView(
          children: <Widget> [
            SizedBox(
              height: height/10,
            ),
            Center( child: Text(
                'REPORT ORPHAN',
                style: TextStyle(fontFamily: 'JosefinSans',fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),
            )),
            SizedBox(
              height: height/10,
            ),
            Align (
              alignment: Alignment.center,
             child: Container(
               width: 300,
               child: TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50)
                  )
              ),
              controller: name,
              )
            )),
            SizedBox(
              height: height/10,
            ),
           Align (
             alignment: Alignment.center,
             child: Container(
             width: 300,
             child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                  labelText: 'Age',
                  hintText: 'Your age',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50)
                  )
              ),
              controller: age,
            )
           )),
            SizedBox(
              height: height/10,
            ),
           Align(
            alignment: Alignment.center,
            child: Container(
              width: 300,
              child: TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Write few lines',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50)
                  )
              ),
              controller: description,
              ))),
            SizedBox(
              height: height/10,
            ),
            Align(
              alignment: Alignment.center,
              child:
              flag1?
              Container(child: Text('Coordinates: $coordinates ',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))):
              Container(
                child:
                ElevatedButton(
                    child: Icon(Icons.add_location_alt),
                    onPressed:
                        () {
                       //addlocation();
                          setState(() {
                            flag1= !flag1;
                          });
                    }
                )
             )),
             SizedBox(
              height: height/10,
             ),

            flag2? Container(
                child: Image.network(imageUrl))
            :
            Align(
                alignment: Alignment.center,
                child:
             Container(
                child:
                FloatingActionButton(
                    child: Icon(Icons.add_a_photo),
                    onPressed:
                        () {
                          //addimage();
                          setState(() {
                            flag2 = !flag2;
                          });
                    }
            ))),
            SizedBox(
              height: height/10,
            ),
         Align(
          alignment: Alignment.center,
          child:
            ElevatedButton(
                child: Text('Notify NGOs'),
                onPressed: () {
                  //uploadtofirestore(context);
                  Navigator.pop(context);
                }
            )),
          SizedBox(
            height: height/10
          )
          ],
        )
       );

  }



}


