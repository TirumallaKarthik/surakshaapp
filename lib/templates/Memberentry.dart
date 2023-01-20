

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:surakshaapp/DBObject.dart';
import 'package:surakshaapp/Databasecon.dart';
import 'package:surakshaapp/templates/Builders.dart';
import 'package:surakshaapp/Scripts/User.dart';

class Memberentry extends StatefulWidget {

  @override
  _entryState createState() => _entryState();
}

class _entryState extends State<Memberentry> {
  late var height;
  late var width;
  late Memberobject user;
  int selected=0;
  Member idx = new Member();
  List<Orphanobject> orphanslist = [];

  ///////////////////base
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    Map args = ModalRoute.of(context)!.settings.arguments as Map;
    user = args['user'];
    debugPrint('Unique Id of the member is ${user.phonenumber}');
    // setState(() {
    //   orphanslist;
    // });


    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(backgroundColor: Colors.black38, title:Text("Suraksha Member ${user.name}")),
        backgroundColor: Colors.black87,
        floatingActionButton: selected==0? FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: (){
              Navigator.of(context).pushNamed('AddOrphan',arguments: {'user':user,'orphanslist':orphanslist});
            }
        ):null,
        bottomNavigationBar:
        BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home'
              ),
              BottomNavigationBarItem(
                  icon:  Icon(Icons.person),
                  label: 'Profile'
              )
            ],
            currentIndex: selected,
            onTap: (int index) {
              setState(() {
                selected = index;
              });
            }
        ),

        body:
        selected == 0? home(context):profile(context)

    );


  }

  ///////////////////widgets


  Widget home(BuildContext context){

     List<Map<String,dynamic>> obj = [
       {'padding':EdgeInsets.zero,'child':Image.asset('assets/ca1.jpg',height: height/4,width: width/2),'decoration':BoxDecoration()},
       {'padding':EdgeInsets.zero,'child':Image.asset('assets/ca2.jpg',height: height/4,width: width/2),'decoration':BoxDecoration()},
       {'padding':EdgeInsets.zero,'child':Image.asset('assets/ca3.jpg',height: height/4,width: width/2),'decoration':BoxDecoration()}
     ];

     return Column(
       children: [
         Expanded( child: CarouselBuilder(height/4,width/2,0.0,obj).builder()),
         SizedBox(height:height/20, width:width),
         FutureBuilder(builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              debugPrint("getting orphans ${user.toString()}");
              return Center(
                  child: CircularProgressIndicator());
            }
            else if(snapshot.connectionState == ConnectionState.done) {
              if(snapshot.hasData)
              {
                return OrphansListViewBuilder(user.type,snapshot.data).builder();
              }
            }
            return Container();
         },
         future: Firestore.getorphandoc(user,'reportedid',user.phonenumber))
       ]
     );
  }

  Widget profile(BuildContext context){
    return ProfileBuilder(height, width, user.name, user.phonenumber, user.state, user.orphans_reported, context).builder();
  }

}