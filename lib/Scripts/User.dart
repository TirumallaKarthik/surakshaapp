import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:surakshaapp/DBObject.dart';
import 'package:surakshaapp/Databasecon.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:twilio_flutter/twilio_flutter.dart';


class User{
  Future<dynamic> getuserdetails(String userid,String type) async {
    var result = [];
    debugPrint('getting results');
    var doc = await Firestore.getdoc(type, userid);
    result.add(type=='member'?Memberobject(doc?['name'],doc?['state'],int.parse(doc?['orphans_reported']),doc?['phonenumber']):Ngoobject(doc?['name'],doc?['state'],int.parse(doc?['orphans_adopted']),doc?['mailid']));
    debugPrint('user entry $result');
    return result.length!=0?result:null;
  }

  Future<dynamic> signout() async {
    await FirebaseAuth.instance.signOut();
  }

}


class Member extends User{
  TextEditingController smscodecontroller = new TextEditingController();

  @override
  Future<dynamic> addorphan(var user,{Orphanobject? orphan,String? id}) async {

    user.orphans_reported+=1;
    Firestore.updatedoc(user.type,user.phonenumber,{'orphans_reported': user.orphans_reported.toString()});

    debugPrint('updated user data with orphans reported ${user.orphans_reported}');

    Map<String, dynamic> data = {
      'name': orphan!.name,
      'age': orphan!.age.toString(),
      'description': orphan!.description,
      'coordinates': orphan!.coordinates,
      'adoptedby': 'Not Yet',
      'reportedby': orphan!.reportedby,
      'imageurl': orphan!.imageurl,
      'adoptedid': 'Not Yet',
      'reportedid': user.phonenumber
    };
    String id = await Firestore.insertdoc('orphan', data) as String;

    debugPrint('added orphan data in firestore ${orphan.toString()}');
    List<String> contacts = await Firestore.getngomailids(user) as List<String>;
    debugPrint('sending mail to ${contacts}');
    this._sendmail(contacts,id,orphan);

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

}


class Ngo extends User{



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

  Future<void> _sendmessage(String phonenumber, Orphanobject obj) async {

    var twilioFlutter = TwilioFlutter(
        accountSid: 'AC4c1628a00871a8ed6917e4ef78434252',
        authToken: '0d8c2fb4970e88d082ddc103efd870eb',
        twilioNumber: '+18083787604');

    await twilioFlutter.sendSMS(
        toNumber: "${phonenumber}", messageBody: 'name: ${obj.name} age: ${obj.age} coordinates: ${obj.coordinates} description: ${obj.description} imageurl: ${obj.imageurl}');

  }

  @override
  Future<dynamic> addorphan(var user, {Orphanobject? orphan,String? id}) async {
    late var reportedid;
    debugPrint('orphan data is null requesting orphan data from firestore');
    var doc = await Firestore.getdoc('orphan',id!) as Map<String,dynamic>;
    orphan = Orphanobject(doc?['name'],int.parse(doc?['age']),doc?['description'],doc?['coordinates'],doc?['adoptedby'],doc?['reportedby'],doc?['imageurl']);
    reportedid = doc?['reportedid'];
    debugPrint('orphan data obtained ${orphan.toString()} ${reportedid}');

    user.orphans_adopted+=1;
    Firestore.updatedoc(user.type, user.mailid, {'orphans_adopted': user.orphans_adopted.toString()});
    debugPrint('updated user data with orphans adopted ${user.orphans_adopted}');
    orphan?.adoptedby = user.name;
    //implement update orphan in firebase
    Firestore.updatedoc('orphan', id!, {'adoptedby': user.name, 'adoptedid': user.mailid});
    this._sendmessage(reportedid,orphan!);

    return orphan;

  }

}


class Orphan{

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