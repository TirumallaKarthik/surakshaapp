
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:surakshaapp/Widgets.dart';
import 'package:surakshaapp/DOB.dart';

class Memberentry extends StatefulWidget {

  @override
  _entryState createState() => _entryState();
}

class _entryState extends State<Memberentry> {
  var height;
  var width;
  int selected=0;
  var details;
  var first=0;
  Widgets _widget = Widgets();
  UserObject _mem = UserObject();
  /////////////////functions



   checkfirst(BuildContext context) async
   {
  //
  //     await FirebaseFirestore.instance.collection('users').doc(phonenumber).get().then((DocumentSnapshot documentSnapshot) {
  //           if (documentSnapshot.exists) {
  //             print('Document exists on the database');
  //                details = documentSnapshot.data as Map;
  //                print('Setting state of the activity');
  //                print("Member information: $name $state $orphans $orp_rep");
  //                setState(() {
  //                   name = details['name'];
  //                   state = details['state'];
  //                   orphans = details['orphans'];
  //                   orp_rep = details['orphans_rep'];
  //                 });
  //             return Text("Document doesnot exist");
  //           }
  //           else{
  //             print("entry does not exist");
  //           }
  //         });

          return Container(child: Text('retrievalable',style: TextStyle(fontSize: 20),));

   }

  ///////////////////base
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    Map args = ModalRoute.of(context)!.settings.arguments as Map;
    _mem.phonenumber = args['phno'];

    print('Unique Id of the member is'+_mem.phonenumber);



    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(backgroundColor: Colors.black38, title:Text('Suraksha Member '+_mem.name)),
        backgroundColor: Colors.black87,
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: (){
              Navigator.of(context).pushNamed('AddOrphan');
            }
        ),
        bottomNavigationBar:
        BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home'
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Search'
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
       FutureBuilder<dynamic>(
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return selected == 0? home(context):(selected == 1?search(context):profile(context));
        },
        future: checkfirst(context)
     )
    );


  }

  ///////////////////widgets


  Widget home(BuildContext context){

     // if(orp_rep==0)
     //   {
     //     print("information: 0 orphans reported so far");
     //     return Column(
     //         children: [
     //           Flexible(child: _widget.carousalslider(context, height, width,'Member')),
     //           //Center( child: ),
     //           SizedBox(
     //               height: height/2,
     //               child: Text('No orphans reported so far',style: TextStyle(color: Colors.amber, fontSize: 20))
     //           )
     //         ]
     //     );
     //
     //   }

     return ListView(
       children: [
         _widget.carousalslider(context, height, width,[AssetImage('assets/ca1.jpg'),AssetImage('assets/ca2.jpg'),AssetImage('assets/ca3.jpg')]),
         _widget.sizedbox(height/10, width),
         //Center(child:_widget.text("NO RESULTS AS OF NOW", 'Staatliches', 30, FontWeight.bold, Colors.white))
         _widget.orphanslst(context, height, width,'Member', {"cdscvsbhasa":{"orphanname":"Rupesh","adoptedby":"Algram"}})
       ]
     );


  }

  Widget search(BuildContext context){
    return Text('search',style: TextStyle(color: Colors.amber));
  }

  Widget profile(BuildContext context){
    var details_map = {
      'name':_mem.name,
      'identity':_mem.phonenumber,
      'state':_mem.state,
      'orphans':_mem.orphans_reported
    };

    return _widget.profiledata(context, height, width, details_map);

  }

}