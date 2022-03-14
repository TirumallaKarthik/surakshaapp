
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


class LandLogin extends StatelessWidget {
  ///////////////////////////////variables used
  TextEditingController mobno = new TextEditingController();
  var height;
  var width;
  late AuthCredential authCred;
  late String vefID;
  late int smscode;
  late User user;
  Widgets obj = Widgets();

  //////////////////////////////functions
  /*
  Future<void> sigin(BuildContext context) async {
    await FirebaseAuth.instance
        .signInWithCredential(this.authCred)
        .then((AuthResult authRes) {

      user = authRes.user;
      print('name:'+user.displayName+'phone:'+user.phoneNumber+'uid:'+user.uid);
      Navigator.pushNamed(context, 'Member', arguments: {'phno':user.phoneNumber,'id':user.uid});
    });
  }

  Future<void> authenticationbyphone(BuildContext context) async
  {

    String phoneNumber = "+91" + mobno.text.toString().trim();

    print(phoneNumber);

    await FirebaseAuth.instance.verifyPhoneNumber(
      /// Make sure to prefix with your country code
      phoneNumber: phoneNumber,

      /// `seconds` didn't work. The underlying implementation code only reads in `milliseconds`
      timeout: Duration(milliseconds: 10000),

      /// If the SIM (with phoneNumber) is in the current device this function is called.
      /// This function gives `AuthCredential`. Moreover `login` function can be called from this callback
      verificationCompleted: (AuthCredential phoneAuthCredential) {
        print('verificationCompleted');
        this.authCred = phoneAuthCredential;
        print(phoneAuthCredential);
        sigin (context);
      },

      /// Called when the verification is failed
      verificationFailed: (AuthException error) {
        obj.showsnackbar(error.toString(),context);
      },

      /// This is called after the OTP is sent. Gives a `verificationId` and `code`
      codeSent: (String verificationId, [ int? code]) {
        print('codeSent');
        this.vefID = verificationId;
        print(verificationId);
        this.smscode = code!;
        print(code.toString());

        this.authCred = PhoneAuthProvider.getCredential(verificationId: this.vefID, smsCode: smscode.toString());
        sigin (context);
      },

      /// After automatic code retrival `tmeout` this function is called
      codeAutoRetrievalTimeout: null,
    );

  }

  authenticationbymail(BuildContext context) async
  {

    FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    bool isUserSignedIn = false;
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
    // get the credentials to (access / id token)
    // to sign in via Firebase Authentication
    final AuthCredential credential =
    GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken
    );
    user = (await auth.signInWithCredential(credential)).user;
    isUserSignedIn = await googleSignIn.isSignedIn();
    isUserSignedIn?Navigator.pushNamed(context,'Ngo',arguments: {'user':user}):obj.showsnackbar('invalid username/password',context);;

  }
*/
  //////////////////////base

  @override
  Widget build(BuildContext context) {

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(backgroundColor: Colors.black38, title: Center(child:Text('Suraksha'))),
        body:
        SizedBox(
            height: height,
            width: width,
            child:
              Carousel(
                  images:
                  [
                    Container(
                        height: height,
                        width: width,

                        child:
                        landing(context)

                    ),


                    Container(
                        height: height,
                        width: width,
                        padding: EdgeInsets.all(40.0),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image:AssetImage('assets/template.png'),
                                fit: BoxFit.cover
                            )
                        ),
                        child:
                        login(context)

                    )
                  ],

                dotSize: 4.0,
                dotSpacing: 40.0,
                dotColor: Colors.lightGreenAccent,
                indicatorBgPadding: 20.0,
                dotBgColor: Colors.purple.withOpacity(0.5),
                borderRadius: false,
                autoplay: false,
                noRadiusForIndicator: true,
        )
        )
    );
  }

  /////////////////////////////widgets

  Widget login(BuildContext context)
  {

    return Column(

      children: [
        SizedBox(
          height: height/4,
          width: width,
        ),
        Row(
          children: [
            Text('If you are a',style: TextStyle(fontFamily: 'Staatliches',fontSize: 30)),
            Text('Member',style: TextStyle(fontFamily: 'Staatliches',fontSize: 32,color: Colors.blue )),
          ]
        ),
        SizedBox(
          height: 20,
          width: width,
        ),
        TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              labelText: 'Mobile Number',
              hintText: 'Enter your mobile number',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50)
              )
          ),
          controller: mobno,
        ),
        SizedBox(
          height: 20,
          width: width,
        ),
        ElevatedButton(
            onPressed: (){
              //authenticationbyphone(context);
              Navigator.pushNamed(context, 'New', arguments: {'key':'8978373698', 'type':'Member'});
              print('clicked sign in');
            },
            style: ElevatedButton.styleFrom(primary: Colors.green),
            child:
            Text('SIGN IN')
        ),
        SizedBox(
          height: 20,
          width: width,
        ),
        Row(
            children: [
              Text('If you are an',style: TextStyle(fontFamily: 'Staatliches',fontSize: 30)),
              Text('NGO',style: TextStyle(fontFamily: 'Staatliches',fontSize: 32,color: Colors.red )),
            ]
        ),
        SizedBox(
          height: 20,
          width: width,
        ),
        SignInButton(
          Buttons.Google,
          onPressed: () {
            //authenticationbymail(context);
            Navigator.pushNamed(context,'Ngo',arguments: {'mailid':'ktirumalla67@gmail.com'});
            print('clicked sign in');
          },
        ),
        SizedBox(
          height: 20,
          width: width,
        )
      ],
    );
  }

  Widget landing(BuildContext context)
  {
    return
    Column(

      children: [
        Expanded(
          //padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
            child:
            Image.asset('assets/Logo.png',height: height/3,width:width/2)
        ),

        Text('Suraksha',style: TextStyle(fontFamily: 'Staatliches',fontSize: 40)),

        SizedBox(
          width: width,
          height: (1/5) * height,
        ),

        Text('Slide to continue',style: TextStyle(fontFamily: 'Staatliches',fontSize: 20)),

        SizedBox(
          width: width,
          height: (1/10) * height,
        ),
      ],
    );
  }

}


