import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:surakshaapp/DBObject.dart';
import 'package:surakshaapp/Databasecon.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';



class Index{
  TextEditingController smscodecontroller = new TextEditingController();

  Future<dynamic> getuserdetails(String type, String userid)async {
      //check if the user data exists in firestore
      var result = [];
      result.add(await Firestore.getdocument(type, userid));
      debugPrint('user entry $result');
      return result.length!=0?result:null;
  }



  Future<dynamic> emailauthenticate(BuildContext context)async{
    GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();
    GoogleSignInAuthentication auth = await googleSignInAccount!.authentication;
    AuthCredential cred = GoogleAuthProvider.credential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(cred);
    debugPrint('authentication successful');
  }


  Future<dynamic> signout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<dynamic> phoneauthenticate(BuildContext context,String number) async {


    FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91'+number,
        timeout: Duration(seconds: 120),
        verificationCompleted: (AuthCredential authCredential){
             FirebaseAuth.instance.signInWithCredential(authCredential).then(
                 (result){
                   Navigator.pushNamed(context, 'New', arguments: {'id':result.user!.phoneNumber,'type':'member'});
                 }
             );
        },
        verificationFailed: (authException){
          print(authException.message);
        },
        codeSent: (verificationId, forceResendingToken){
          //show dialog to take input from the user
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                title: Text("Enter SMS Code"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: smscodecontroller,
                    ),

                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text("Done"),
                    onPressed: () {
                      var smsCode = smscodecontroller.text.trim();
                      AuthCredential _credential =PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
                      FirebaseAuth.instance.signInWithCredential(_credential).then((result){
                        Navigator.pushNamed(context, 'New', arguments: {'id':result.user!.phoneNumber,'type':'member'});
                      });
                    },
                  )
                ],
              )
          );
        },
        codeAutoRetrievalTimeout: (String verificationId){
          print(verificationId);
          debugPrint("Timeout");
        });
  }

  Future<dynamic> addorphan(var user,{Orphanobject? orphan,String? id}) async {
     /*if member
     //I need to increment pointer in Memberobject
     //I need to update the same in Member firebase
     //I need to add record in Orphan firebase
     //I need to send a mail to the Ngos
     //if ngo
     //I need to increment pointer in Ngoobject
     //I need to update the same in Ngo firebase
     //I need to update record in Orphan firebase
     //I need to send a message to the Member
    */
     late var reportedid;

     //if orphanobject is null
     if(orphan == null){
       //get the orphanobject from firebase using id
       debugPrint('orphan data is null requesting orphan data from firestore');
       List<dynamic> res = await Firestore.getdocument('orphan',id!) as List<dynamic>;
       orphan = res[0]??null;
       reportedid = res[1]??null;
       debugPrint('orphan data obtained ${orphan.toString()} ${reportedid}');
     }
     //increment the orphans count
     if(user.type == 'member')
       {

           //implement adding orphan to firebase
           //send a mail to all ngos
           user.orphans_reported+=1;
           Firestore.updatedocument(user.type, user.phonenumber, count:user.orphans_reported.toString());
           debugPrint('updated user data with orphans reported ${user.orphans_reported}');
           String id = await Firestore.insertdocument('orphan', orphan!,user.phonenumber) as String;
           debugPrint('added orphan data in firestore ${orphan.toString()}');
           List<String> contacts = await Firestore.getcontact(user) as List<String>;
           debugPrint('sending mail to ${contacts}');
           this._sendmail(contacts,id,orphan);
       }
     else{
           user.orphans_adopted+=1;
           Firestore.updatedocument(user.type, user.mailid, count:user.orphans_adopted.toString());
           debugPrint('updated user data with orphans adopted ${user.orphans_adopted}');
           orphan?.adoptedby = user.name;
           //implement update orphan in firebase
           Firestore.updatedocument('orphan', id!, userid:user.mailid, username:user.name);
           this._sendmessage(reportedid,orphan!);

           return orphan;
     }


  }

  Future<void> _sendmail(List<String> maillist, String id,Orphanobject obj) async {

    debugPrint('receipent mail list ${maillist}');
    final Email email = Email(
      body: 'name: ${obj.name} age: ${obj.age} coordinates: ${obj.coordinates} description: ${obj.description} imageurl: ${obj.imageurl}',
      subject: 'Found orphan ID: $id',
      recipients: maillist,
      isHTML: false,
    );
    await FlutterEmailSender.send(email);

  }

  Future<void> _sendmessage(String phonenumber, Orphanobject obj) async {

    List<String> recipients = ["91${phonenumber}"];

    await sendSMS(message: 'name: ${obj.name} age: ${obj.age} coordinates: ${obj.coordinates} description: ${obj.description} imageurl: ${obj.imageurl}', recipients: recipients);

  }

  Future<bool> _checklocationaccess(BuildContext context) async {

    if(! await Geolocator.isLocationServiceEnabled()){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location services are disabled. Please enable the services')));
      return false;
    }

    if (await Geolocator.checkPermission() == LocationPermission.denied) {
      if (await Geolocator.requestPermission() == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    return true;

  }

  Future<String?> getimage(BuildContext context,String name) async {
    //from camera get the image and store it in firebase
    //get the url and pass it
    final XFile photo = await ImagePicker().pickImage(source: ImageSource.camera) as XFile;
    File photofile = File(photo.path);
    print('picked the file from camera');
    TaskSnapshot snapshot = await FirebaseStorage.instance.ref().child('images/${name}').putFile(photofile);
    print('uploaded file into firebase storage');
    String fileurl = await snapshot.ref.getDownloadURL();
    return fileurl;

  }

  Future<String?> getlocation(BuildContext context) async {
    //from location get the location address and pass it
    if(await this._checklocationaccess(context))
    {
      var coordinates;
      print('obtained location access');
      await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high)
          .then((Position position) {
        print('location ${position.latitude} ${position.longitude}');
        coordinates = 'latitude ${position.latitude} longitude ${position.longitude}';
      }).catchError((e) {
      debugPrint(e);
      });
      return coordinates;
    }

  }
}