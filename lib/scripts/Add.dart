

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

class Addorphan extends StatefulWidget {

  @override
  _entryState createState() => _entryState();
}

class _entryState extends State<Addorphan> {

  ///////////////////////////////variables used
  var height;
  var imageUrl;
  var width;
  var flag1 = 1;
  var flag2 = 1;
  var mobno;
  var coordinates;
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
    Map args = ModalRoute.of(context)!.settings.arguments as Map;
    mobno = args['phno'];

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(backgroundColor: Colors.black38, title:Text('Hi Tirumalla Karthik')),
        backgroundColor: Colors.white,
        body:
     Center( child:
        Column(
          children: <Widget> [
            SizedBox(
                height: 50
            ),
            Text(
                'REPORT ORPHAN',
                style: TextStyle(fontFamily: 'JosefinSans',fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),
            ),
            SizedBox(
                height: 30
            ),
            Container(
               width: 250,
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
            ),
            SizedBox(
                height: 20
            ),
            Container(
             width: 250,
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
           ),
            SizedBox(
                height: 20
            ),
            Container(
              width: 250,
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
             )),
            SizedBox(
                height: 20
            ),
            /*
            flag1==0?
            Container(child: Text('Coordinates: $coordinates ',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))):
            Container(
                child:
                ElevatedButton(
                    child: Icon(Icons.add_location_alt),
                    onPressed:
                        () {
                       addlocation();
                    }
                )
            ),
            SizedBox(
                height: 50
            ),
            flag2==0? Expanded(
                child:
                Container(child: Image.network(imageUrl.toString())))
            :
            Container(
                child:
                FloatingActionButton(
                    child: Icon(Icons.add_a_photo),
                    onPressed:
                        () {
                          addimage();
                    }
                )
            ),
            SizedBox(
                height: 20
            ),
            ElevatedButton(
                child: Text('Notify NGOs'),
                onPressed:
                    ()
                {
                  uploadtofirestore(context);
                }
            ),
            SizedBox(
              height: 50
            )
            */
          ],
        )
       )
    );

  }



}


