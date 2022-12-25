
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:surakshaapp/Scripts/Index.dart';
import 'package:flutter/material.dart';
import 'package:surakshaapp/DBObject.dart';
import 'package:surakshaapp/templates/Builders.dart';

import 'package:surakshaapp/Databasecon.dart';

class Ngoentry extends StatefulWidget {

  @override
  _entryState createState() => _entryState();
}

class _entryState extends State<Ngoentry> {
  late var height;
  late var width;
  int selected=0;
  var orphans;
  late Ngoobject user;
  TextEditingController namecon = new TextEditingController();
  TextEditingController statecon = new TextEditingController();
  List<Orphanobject> orphanslist = [];
  Index idx = new Index();

  ///////////////////base
  @override
  Widget build(BuildContext context) {

    //get passed arguments
    Map args = ModalRoute.of(context)!.settings.arguments as Map;
    user = args['user'] as Ngoobject;
    print('Unique Id of the member is ${user.mailid}');
    setState(() {
      orphanslist;
    });

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(backgroundColor: Colors.black38, title:Text('Suraksha Ngo '+user.name)),
              backgroundColor: Colors.black87,
              floatingActionButton: selected==0? FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: (){
                    Navigator.of(context).pushNamed('TagOrphan',arguments: {'user':user,'orphanslist':orphanslist});
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
                        icon: Icon(Icons.person),
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

    // return Container(
    //     child:
    //     FutureBuilder<dynamic>(
    //         builder: (context, snapshot){
    //           if(snapshot.hasData)
    //           { return snapshot.data;}
    //
    //           return Center(child: CircularProgressIndicator());
    //         },
    //         future: checkfirst(emailid,context)
    //     )
    // );

  }

  ///////////////////widgets

  Widget home(BuildContext context){
    //orphanslist.add(Orphanobject());


    List<Map<String,dynamic>> obj = [
      {'padding':EdgeInsets.zero,'child':Image.asset('assets/ca1.jpg',height: height/4,width: width/2),'decoration':BoxDecoration()},
      {'padding':EdgeInsets.zero,'child':Image.asset('assets/ca2.jpg',height: height/4,width: width/2),'decoration':BoxDecoration()},
      {'padding':EdgeInsets.zero,'child':Image.asset('assets/ca3.jpg',height: height/4,width: width/2),'decoration':BoxDecoration()}
    ];
    return Column(
        children: [
            Expanded(child:CarouselBuilder(height/4,width/2,0.0,obj).builder()),
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
            future: Firestore.getorphandocumentsbyuser(user))
        ]
    );
  }

  Widget profile(BuildContext context){
    return ProfileBuilder(height, width, user.name, user.mailid, user.state, user.orphans_adopted, context).builder();
  }

}