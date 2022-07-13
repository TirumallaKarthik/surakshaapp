//
// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class New extends StatelessWidget {
//
//   var height;
//   var width;
//   var phonenumber;
//   var mailid;
//   TextEditingController namecon = new TextEditingController();
//   TextEditingController statecon = new TextEditingController();
//
//
//   checkfirst_phno(var mobno,BuildContext context) async
//   {
//     await FirebaseFirestore.instance.collection('users').doc(mobno).get().then((DocumentSnapshot documentSnapshot) {
//       if (documentSnapshot.exists) {
//         print('Document exists on the database');
//            var mem_params = documentSnapshot.data as Map;
//            Navigator.pushNamed(context, 'Member', arguments: {'phno':phonenumber,'params':mem_params});
//       }
//       else{
//         print("entry does not exist");
//         return Text("Document doesnot exist");
//       }
//     });
//
//   }
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     height = MediaQuery.of(context).size.height;
//     width = MediaQuery.of(context).size.width;
//
//     Map args = ModalRoute.of(context)!.settings.arguments as Map;
//
//     print("Switched to New Activity");
//
//     if(args['type']=='Member')
//       {
//         phonenumber = args['key'];
//         print("obtained user: $phonenumber");
//       }else{
//         mailid = args['key'];
//         print("obtained user: $mailid");
//     }
//
//     Navigator.pushNamed(context, 'Member', arguments: {'phno':phonenumber});
//
//     print("checking if entry exists");
//
//     return Container(
//         child:
//         FutureBuilder<dynamic>(
//             builder: (context, snapshot){
//               if(snapshot.connectionState == ConnectionState.waiting){
//                    return Center(child: CircularProgressIndicator());
//                 }
//               return Center(child: register(context));
//
//             },
//             future: checkfirst_phno(phonenumber,context)
//         )
//     );
//
//
//   }
//
//   //Widgets
//
//   Widget register(BuildContext context)
//   {
//      return Scaffold(
//          resizeToAvoidBottomInset: false,
//          appBar: AppBar(backgroundColor: Colors.black38, title: Center(child:Text('Suraksha'))),
//          backgroundColor: Colors.white,
//          body: Center(
//              child:
//
//              Container(
//                height: height / 2,
//                width: width / 2,
//                child:
//
//                Column(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    Text('Fill up', style: TextStyle(fontFamily: 'Staatliches',fontSize: 30,color: Colors.green)),
//                    SizedBox(
//                      height: height / 10,
//                    ),
//                    TextField(
//                      keyboardType: TextInputType.text,
//                      decoration: InputDecoration(
//                          labelText: 'Name',
//                          hintText: 'Enter your full name',
//                          border: OutlineInputBorder(
//                              borderRadius: BorderRadius.circular(50)
//                          )
//                      ),
//                      controller: namecon,
//                    ),
//                    SizedBox(
//                      height: height / 10,
//                    ),
//                    TextField(
//                      keyboardType: TextInputType.text,
//                      decoration: InputDecoration(
//                          labelText: 'State',
//                          hintText: 'Enter your state',
//                          border: OutlineInputBorder(
//                              borderRadius: BorderRadius.circular(50)
//                          )
//                      ),
//                      controller: statecon,
//                    ),
//                    TextButton(onPressed: ()  {
//                      var mem_params = {
//                        'name':namecon.text,
//                        'state':statecon.text,
//                        'orphans_rep':0,
//                        'orphans':{}
//                      };
//                      FirebaseFirestore.instance.collection('users').doc(phonenumber).set(
//                          mem_params).then( (document){
//                        print('added document $phonenumber and navigating to member activity');
//                      });
//                      Navigator.pushNamed(context, 'Member', arguments: {'phno':phonenumber});
//                    },
//                        child: Text('Go', style: TextStyle(
//                            color: Colors.purple, fontSize: 18.0),))
//                  ],
//                ),
//              )
//          )
//      );
//   }
//
// }
