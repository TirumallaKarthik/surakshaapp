
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class New extends StatelessWidget {

  var height;
  var width;
  var phonenumber;
  var mailid;
  TextEditingController namecon = new TextEditingController();
  TextEditingController statecon = new TextEditingController();

  checkfirst(var mobno,BuildContext context) async
  {
    var document = await FirebaseFirestore.instance.collection('users').doc(mobno).get();
    print('document: '+document.toString());
    if(!document.exists) {
            //get details
            print("entry doesnot exist");
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
                      Text('Fill up', style: TextStyle(fontFamily: 'Staatliches',fontSize: 30,color: Colors.green)),
                      SizedBox(
                        height: height / 10,
                      ),
                      TextField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                             labelText: 'Name',
                            hintText: 'Enter your full name',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50)
                            )
                        ),
                        controller: namecon,
                      ),
                      SizedBox(
                        height: height / 10,
                      ),
                      TextField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: 'State',
                            hintText: 'Enter your state',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50)
                            )
                        ),
                        controller: statecon,
                      ),
                      TextButton(onPressed: ()  {
                        FirebaseFirestore.instance.collection('users').doc(mobno).set(
                            {
                              'name':namecon.text,
                              'state':statecon.text,
                              'orphans_rep':0,
                              'orphans':{}

                            }).then( (document){
                              print('added');
                              Navigator.pushNamed(context, 'Member', arguments: {'phno':phonenumber});
                            });
                      },
                          child: Text('Go', style: TextStyle(
                              color: Colors.purple, fontSize: 18.0),))
                    ],
                  ),
                )
               )
            );


    }else{
       print("entry already exist");
      //return Container(child: Text('contains',style: TextStyle(fontSize: 20),));
      Navigator.pushNamed(context, 'Member', arguments: {'phno':phonenumber});

    }



  }




  @override
  Widget build(BuildContext context) {

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    Map args = ModalRoute.of(context)!.settings.arguments as Map;

    if(args['type']=='Member')
      {
        phonenumber = args['key'];
      }else{
        mailid = args['key'];
    }
    print("checking if entry exists");

    return Container(
        child:
        FutureBuilder<dynamic>(
            builder: (context, snapshot){
              if(snapshot.hasData)
              { return snapshot.data;}
              else {
                return Center(child: CircularProgressIndicator());
              }
            },
            future: checkfirst(phonenumber,context)
        )
    );


  }


}
