
import 'package:cloud_firestore/cloud_firestore.dart';
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

class Tagorphan extends StatelessWidget {


  ///////////////////////////////variables used
  var height;
  var width;
  var flag = 0;
  var mailid;
  TextEditingController id = new TextEditingController();

  //////////////////////////////functions
  update(var userid) async {

    await FirebaseFirestore.instance.collection('ngos').doc(mailid).get().then(
            (document) async
        {
          var children = document.data()!['orphans'];
          var ngo = document.data()!['name'];
          children.add({id.text.split(',')[0],ngo});
          print('checkng if document exists');
          if(document.exists)
          {
            await FirebaseFirestore.instance.collection('ngos').doc(mailid).set(
                {
                  'orphans_adop':document.data()!['orphans_adop']+1,
                  'orphans':children
                });

            await FirebaseFirestore.instance.collection('orphans').doc(userid).set(
                {
                  'adoptedby': ngo
                });
          }
        }
    );

  }


  tagorphan(BuildContext context, var height, var width,String id) async {
    var orphanname = id.split(',')[0];

    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return
            AlertDialog(
                title: Text('Confirmation'),
                content: Builder(
                    builder: (context) {
                      return
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Are you sure you want to TAG $orphanname?'),
                            Row(
                              children: [
                                ElevatedButton(
                                    onPressed: () { update(id); },
                                    child: Text('Yes')
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                ElevatedButton(
                                    onPressed: () {  Navigator.of(context).pop(); },
                                    child: Text('No')
                                )
                              ],
                            )
                          ],
                        );
                    }
                )
            );
        }
    );
  }

  //////////////////////base

  @override
  Widget build(BuildContext context) {

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    Map args = ModalRoute.of(context)!.settings.arguments as Map;
    mailid = args['mail'];

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(backgroundColor: Colors.black38, title:Text('Hi Vyasa Bharathi')),
        backgroundColor: Colors.white,
        body:
        Center( child:
         Column(
          children: <Widget> [
            SizedBox(
                height: 150
            ),
            Text(
              'TAG ORPHAN',
              style: TextStyle(fontFamily: 'JosefinSans',fontSize: 45,fontWeight: FontWeight.bold,color: Colors.black),
            ),
            SizedBox(
                height: 50
            ),
            Text(
              'ENTER THE ID TO TAG THE ORPHAN',
              style: TextStyle(fontFamily: 'JosefinSans',fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black),
            ),
            SizedBox(
                height: 50
            ),
            SizedBox(
                width: 250,
                child: TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: 'Id',
                      hintText: 'Enter id',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50)
                      )
                  ),
                  controller: id,
                )
            ),
            SizedBox(
                height: 50
            ),
            ElevatedButton(
                child: Text('Tag Orphan'),
                onPressed:
                    ()
                {
                  tagorphan(context,height,width,id.text);
                }
            ),
            SizedBox(
                height: 50
            )

          ],
        )
        )
    );

  }



}


