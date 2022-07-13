
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:surakshaapp/Widgets.dart';


class Login extends StatelessWidget {
  ///////////////////////////////variables used
  TextEditingController mobno = new TextEditingController();
  var height;
  var width;
  Widgets _widget = Widgets();
  late AuthCredential authCred;
  late String vefID;
  late int smscode;
  late User user;


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
        body:
        SizedBox(
            height: height,
            width: width,
            child:
              Carousel(
                  images:
                  [
                    _widget.container(height, width, EdgeInsets.zero, landing(context),BoxDecoration()),
                    _widget.container(height, width, EdgeInsets.all(40.0), login(context),BoxDecoration(
                        image: DecorationImage(
                        image:AssetImage('assets/template.png'),
                        fit: BoxFit.cover
                    )))
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

  /////////////////////////////_widgets

  Widget login(BuildContext context)
  {

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _widget.sizedbox(height/4, width),
        Row(
          children: [
            _widget.text('If you are a','Staatliches',30, FontWeight.normal, Colors.black),
            _widget.text('Member','Staatliches',32, FontWeight.normal, Colors.blue)
          ]
        ),
        //_widget.sizedbox(height/20, width),
        _widget.textfield(TextInputType.number,'Mobile Number','Enter your mobile number',BorderRadius.circular(50),mobno),
       // _widget.sizedbox(height/20, width),
        ElevatedButton(
            onPressed: (){
              //authenticationbyphone(context);
              Navigator.pushNamed(context, 'Member', arguments: {'phno':'8978373698'});
              print('clicked sign in');
            },
            style: ElevatedButton.styleFrom(primary: Colors.green),
            child:
            Text('SIGN IN')
        ),
        //_widget.sizedbox(height/20, width),
        Row(
            children: [
              _widget.text('If you are an','Staatliches',30, FontWeight.normal, Colors.black),
              _widget.text('NGO','Staatliches',32, FontWeight.normal, Colors.red)
            ]
        ),
        //_widget.sizedbox(height/20, width),
        SignInButton(
          Buttons.Google,
          onPressed: () {
            //authenticationbymail(context);
            Navigator.pushNamed(context,'Ngo',arguments: {'mailid':'ktirumalla67@gmail.com'});
            print('clicked sign in');
          }
        ),
        _widget.sizedbox(height/8, width),
      ],
    );
  }

  Widget landing(BuildContext context)
  {
    return Column(
      children: [
        Expanded(
          //padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
            child:
            Image.asset('assets/Logo.png',height: height/3,width:width/2)
        ),
        _widget.text('Suraksha','Staatliches',40, FontWeight.normal, Colors.black),
        _widget.sizedbox((1/5) * height, width),
        _widget.text('Slide to continue','Staatliches',30, FontWeight.normal, Colors.black),
        _widget.sizedbox((1/10) * height, width)
      ],
    );
  }

}


