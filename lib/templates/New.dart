
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:surakshaapp/DBObject.dart';
import 'package:surakshaapp/Scripts/Index.dart';
import 'package:surakshaapp/Databasecon.dart';
import 'package:surakshaapp/templates/Builders.dart';
class New extends StatelessWidget {

  late var height;
  late var width;
  Index idx = new Index();
  late var user;
  late List<Orphanobject> orphanlst;
  TextEditingController namecon = new TextEditingController();
  TextEditingController statecon = new TextEditingController();


  // checkfirst_phno(var mobno,BuildContext context) async
  // {
  //   await FirebaseFirestore.instance.collection('users').doc(mobno).get().then((DocumentSnapshot documentSnapshot) {
  //     if (documentSnapshot.exists) {
  //       print('Document exists on the database');
  //          var mem_params = documentSnapshot.data as Map;
  //          Navigator.pushNamed(context, 'Member', arguments: {'phno':phonenumber,'params':mem_params});
  //     }
  //     else{
  //       print("entry does not exist");
  //       return Text("Document doesnot exist");
  //     }
  //   });
  //
  // }




  @override
  Widget build(BuildContext context) {

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    Map args = ModalRoute.of(context)!.settings.arguments as Map;
    debugPrint("Switched to New Activity with $args");

    return SizedBox(
        height: height,
        width: width,
        child:
        FutureBuilder<dynamic>(
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                   debugPrint("checking if entry exists ${args['id']} ${args['type']}");
                   return Center(child: CircularProgressIndicator());
                }
              else if(snapshot.connectionState == ConnectionState.done) {
                if(snapshot.hasData)
                  {
                     debugPrint("entry exists ${args['id']} ${args['type']} ${snapshot.data}");
                     user = snapshot.data[0];
                     WidgetsBinding.instance!.addPostFrameCallback((_){
                       // Add Your Code here.
                       var route = args['type']=='member'?'Memberentry':'Ngoentry';
                       Navigator.pushReplacementNamed(context, route, arguments: {'user':user});
                     });

                  }
                else{
                  debugPrint("entry does not exist ${args['id']} ${args['type']}");
                  return Center(child: register(context,args));
                }
              }

              return Container();

            },
            future: idx.getuserdetails(args['type'],args['id'])
        )
    );


  }

  //Widgets

  Widget register(BuildContext context,Map arguments)
  {
     return Scaffold(
         resizeToAvoidBottomInset: false,
         appBar: AppBar(backgroundColor: Colors.black38, title: Center(child:Text('Suraksha'))),
         backgroundColor: Colors.white,
         body: Center(
             child:

             Container(
               height: height / 2,
               width: width / 2,
               child:

               Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: <Widget>[
                   TextBuilder('Fill up','Staatliches',30.0,FontWeight.normal,Colors.green).builder(),
                   SizedBox(
                     height: height / 10,
                   ),
                   TextInputBuilder(TextInputType.text, 'Name','Enter your full name',  BorderRadius.circular(50), namecon).builder(),
                   SizedBox(
                     height: height / 10,
                   ),
                   TextInputBuilder(TextInputType.text, 'State','Enter your state',  BorderRadius.circular(50), statecon).builder(),
                   TextButton(onPressed: () {
                     //add document to the user db
                    WidgetsBinding.instance!.addPostFrameCallback((_) {
                      if (arguments['type'] == 'member') {
                        user = Memberobject(
                            namecon.text, statecon.text, 0, arguments['id']);
                        Firestore.insertdocument(arguments['type'], user);
                        Navigator.pushReplacementNamed(context, 'Memberentry',
                            arguments: {'user': user});
                      }
                      else {
                        user = Ngoobject(
                            namecon.text, statecon.text, 0, arguments['id']);
                        Firestore.insertdocument(arguments['type'], user);
                        Navigator.pushReplacementNamed(context, 'Ngoentry',
                            arguments: {'user': user});
                      }
                    });

                     },
                    child: TextBuilder('Go','Staatliches',18.0,FontWeight.normal,Colors.purple).builder(),
                   )],
               ),
             )
         )
     );
  }

}
