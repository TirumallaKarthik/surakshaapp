

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:surakshaapp/templates/Builders.dart';
import 'package:surakshaapp/DBObject.dart';
import 'package:surakshaapp/Scripts/User.dart';


class Tagorphan extends StatelessWidget {


  ///////////////////////////////variables used
  late var height;
  late var width;
  late Ngoobject user;
  late List<Orphanobject> orphanlst;
  Ngo idx = new Ngo();
  TextEditingController id = new TextEditingController();


  //////////////////////base


  @override
  Widget build(BuildContext context) {

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    Map args = ModalRoute.of(context)!.settings.arguments as Map;
    user = args['user'];
    orphanlst = args['orphanslist'];

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(backgroundColor: Colors.black38, title:Text('Hi ${user.name}')),
        backgroundColor: Colors.white,
        body:
        Center(
            child:
         Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget> [
           Center( child:
                TextBuilder('TAG ORPHAN', 'JosefinSans', 45.0, FontWeight.bold, Colors.black).builder()
            ),
            Center( child:
                TextBuilder('ENTER THE ID TO TAG THE ORPHAN', 'JosefinSans', 15.0, FontWeight.bold, Colors.black).builder()
            ),
            Container(
                width: 250,
                child:
                TextInputBuilder(TextInputType.text, 'Id', 'Enter id', BorderRadius.circular(50), id).builder()
            ),
            ElevatedButton(
                child: Text('Tag Orphan'),
                onPressed: () async
                {
                  orphanlst.add(await idx.addorphan(user,id:id.text) as Orphanobject);
                  //Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, 'Ngoentry', arguments: {'user':user});
                }
            ),
            SizedBox(height:height/8, width:width)

          ],
        )
        )
    );

  }



}


