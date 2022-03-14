
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:surakshaapp/widgets.dart';

class Memberentry extends StatefulWidget {

  @override
  _entryState createState() => _entryState();
}

class _entryState extends State<Memberentry> {
  var height;
  var width;
  int selected=0;
  var name;
  var state;
  var orphans;
  var orp_rep;
  var details;
  var phonenumber;
  var first=0;
  /////////////////functions



  checkfirst(BuildContext context) async
  {


      var document = await FirebaseFirestore.instance.collection('users').doc(phonenumber).get();

      if(document.exists) {
             //get details
         setState(() {
            details = document.data as Map;
            name = details['name'];
            state = details['state'];
            orphans = details['orphans'];
            orp_rep = details['orphans_rep'];
          });

         //return Container(child: Text('retrievalable',style: TextStyle(fontSize: 20),));

        print("information: $name $state $orphans $orp_rep");

        return selected == 0? home(context):(selected == 1?search(context):profile(context));

    }
      else{
        return Container(child: Text('not retrievalable',style: TextStyle(fontSize: 20),));
      }
  }

  ///////////////////base
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    Map args = ModalRoute.of(context)!.settings.arguments as Map;
    phonenumber = args['phno'];
    //print('Here is $phonenumber');


    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(backgroundColor: Colors.black38, title:Text('Hi $name')),
        backgroundColor: Colors.black87,
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: (){
              Navigator.of(context).pushNamed('Add',arguments: {'phno':phonenumber});
            }
        ),
        bottomNavigationBar:
        BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  //title: Text('Home')
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  //title: Text('Search')
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  //title: Text('Profile')
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
          if(snapshot.hasData)
          { return snapshot.data;}
          else {
            return Center(child: CircularProgressIndicator());
          }
        },
        future: checkfirst(context)
     )
    );


  }

  ///////////////////widgets
  var obj = Widgets();

  Widget home(BuildContext context){

     if(orp_rep==0)
       {
         print("information: 0 orphans reported so far");
         return Column(
             children: [
               Flexible(child: obj.carousalslider(context, height, width,'Member')),
               //Center( child: ),
               SizedBox(
                   height: height/2,
                   child: Text('No orphans reported so far',style: TextStyle(color: Colors.amber, fontSize: 20))
               )
             ]
         );

       }

     return Column(
       children: [
         Expanded(child: obj.carousalslider(context, height, width,'Member')),
         obj.orphanslst(context, height, width,'Member',orphans)
       ]
     );

  }

  Widget search(BuildContext context){
    return Text('search',style: TextStyle(color: Colors.amber));
  }

  Widget profile(BuildContext context){


    Map<String,dynamic> gidetails = {
      'name':name,
      'state':state,
      'contact':phonenumber,
      'orphansreported':orp_rep
    };
    return obj.profiledata(context, height, width, 'Member',gidetails);

  }

}