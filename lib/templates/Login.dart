
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:surakshaapp/templates/Builders.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:surakshaapp/Scripts/User.dart';

class Login extends StatelessWidget {
  ///////////////////////////////instance variables used
  late var height;
  late var width;
  late var user;
  bool loginflag=false;
  String? emailid;
  TextEditingController mobno = new TextEditingController();
  // var auth = FirebaseAuth.instance;



  //////////////////////base

  @override
  Widget build(BuildContext context) {

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    List<Map<String,dynamic>> objects = [
      {'padding': EdgeInsets.zero, 'child': landing(context), 'decoration': BoxDecoration()},
      {'padding': EdgeInsets.all(40.0), 'child': login(context), 'decoration': BoxDecoration(image: DecorationImage(image:AssetImage('assets/template.png'),fit: BoxFit.cover))}
    ];

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body:
        SizedBox(
            height: height,
            width: width,
            child: CarouselBuilder(height,width,4.0,objects).builder()
        )
    );
  }

  /////////////////////////////_widgets

  Widget login(BuildContext context)
  {


    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: height/4
        ),
        Row(
          children: [
            TextBuilder('If you are a','Staatliches',30.0, FontWeight.normal, Colors.black).builder(),
            TextBuilder(' Member','Staatliches',32.0, FontWeight.normal, Colors.blue).builder()
          ]
        ),
        TextInputBuilder(TextInputType.number,'Mobile Number','Enter your mobile number',BorderRadius.circular(50),mobno).builder(),
        ElevatedButton(
            onPressed: ()async{
              debugPrint('Member login clicked');
              //await Member().phoneauthenticate(context,mobno.text);
              Navigator.pushNamed(context, 'New', arguments: {'id':'+918978373698','type':'member'});
            },
            style: ElevatedButton.styleFrom(primary: Colors.green),
            child:
            Text('SIGN IN')
        ),
        Row(
            children: [
              TextBuilder('If you are an','Staatliches',30.0, FontWeight.normal, Colors.black).builder(),
              TextBuilder(' NGO','Staatliches',32.0, FontWeight.normal, Colors.red).builder()
            ]
        ),
        SignInButton(
          Buttons.Google,
          onPressed: ()async{
            debugPrint('NGO login clicked');
            await Ngo().emailauthenticate(context).then((_){
               Navigator.pushNamed(context, 'New', arguments: {'id':FirebaseAuth.instance.currentUser?.email,'type':'ngo'});
            });
            //Navigator.pushNamed(context, 'New', arguments: {'id':'ktirumalla67@gmail.com','type':'ngo'});
          }
        ),
        SizedBox(
            height: height/8
        ),
      ],
    );
  }

  Widget landing(BuildContext context)
  {
    return Column(
      children: [
        Expanded(
           child:
            Image.asset('assets/Logo.png',height: height/3,width:width/2)
        ),
        TextBuilder('Suraksha','Staatliches',40.0, FontWeight.normal, Colors.black).builder(),
        SizedBox(
            height: (1/5) * height
        ),
        TextBuilder('Slide to continue','Staatliches',30.0, FontWeight.normal, Colors.black).builder(),
        SizedBox(
            height: (1/10) * height
        )
      ],
    );
  }

}


