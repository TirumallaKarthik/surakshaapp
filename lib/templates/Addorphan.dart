

import 'dart:io';
import 'package:surakshaapp/templates/Builders.dart';
import 'package:surakshaapp/DBObject.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:surakshaapp/Scripts/User.dart';



class Addorphan extends StatefulWidget {

  @override
  _entryState createState() => _entryState();
}

class _entryState extends State<Addorphan> {

  ///////////////////////////////variables used
  late var height;
  late var width;
  late Memberobject user;
  late List<Orphanobject> orphanlst;
  Orphan orp = new Orphan();
  Member mem = new Member();
  var flag1 = false;
  var flag2 = false;
  var imageurl = "https://picsum.photos/200";
  var coordinates = "30 N 20 E";
  TextEditingController name = new TextEditingController();
  TextEditingController description = new TextEditingController();
  TextEditingController age = new TextEditingController();

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
        appBar: AppBar(backgroundColor: Colors.black38, title:Text('Suraksha Member '+user.name)),
        backgroundColor: Colors.white,
        body:
        ListView(
          children: <Widget> [
            SizedBox(
              height: height/10,
            ),
            Center( child: TextBuilder('REPORT ORPHAN','JosefinSans',20.0,FontWeight.bold,Colors.black).builder()),
            SizedBox(
              height: height/10,
            ),
            Align (
                alignment: Alignment.center,
             child: Container(
               width: 300,
               child: TextInputBuilder(TextInputType.text,'Name','Enter name',BorderRadius.circular(50),name).builder()
            )),
            SizedBox(
              height: height/20,
            ),
           Align (
             alignment: Alignment.center,
             child: Container(
             width: 300,
              child: TextInputBuilder(TextInputType.number,'Age','Your age',BorderRadius.circular(50),age).builder()
           )),
            SizedBox(
              height: height/20,
            ),
           Align(
            alignment: Alignment.center,
            child: Container(
              width: 300,
              child: TextInputBuilder(TextInputType.text,'Description','Write few lines',BorderRadius.circular(50), description).builder()
            )),
            SizedBox(
              height: height/20,
            ),
            Align(
              alignment: Alignment.center,
              child: flag1?
              FutureBuilder(
                  builder: (ctx,snapshot){
                    //print('future builder called');
                    if(snapshot.connectionState == ConnectionState.done){
                         if(snapshot.hasData){
                            coordinates = snapshot.data as String;
                            return Container(child: TextBuilder('Coordinates: ${coordinates}','JosefinSans',14.0,FontWeight.bold,Colors.black).builder());
                         }
                       }
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Container();
                  },
                  future: orp.getlocation(context))
                :
                Container(
                  child:
                  ElevatedButton(
                      child: Icon(Icons.add_location_alt),
                      onPressed:
                          () {
                            print('$flag1');
                            setState(() {
                              flag1= !flag1;
                            });
                            print('changed to $flag1');
                      }
                  )
               )),
             SizedBox(
              height: height/20,
             ),

            flag2?
              FutureBuilder(
                builder: (ctx,snapshot){
                  print('future builder called');
                  print('$snapshot');
                  if(snapshot.connectionState == ConnectionState.done){
                    if(snapshot.hasData){
                      imageurl = snapshot.data as String;
                      return  Container(
                          height: height/3,
                          width: width/2,
                          child: Image.network(imageurl));
                    }
                  }
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(
                      child: Container(child:CircularProgressIndicator()),
                    );
                  }
                  return Container();
                },
                future: orp.getimage(context,name.text))
                :
              Align(
                  alignment: Alignment.center,
                  child:
               Container(
                  child:
                  FloatingActionButton(
                      child: Icon(Icons.add_a_photo),
                      onPressed:
                          () {
                            print('$flag2');
                            setState(() {
                              flag2 = !flag2;
                            });
                            print('changed to $flag2');
                      }
              ))),
            SizedBox(
              height: height/20,
            ),
            Align(
            alignment: Alignment.center,
            child:
              ElevatedButton(
                child: Text('Notify NGOs'),
                onPressed: () {
                  Orphanobject orphan = new Orphanobject(name.text, int.parse(age.text), description.text, coordinates, 'Not Yet', user.name, imageurl);
                  orphanlst.add(orphan);
                  mem.addorphan(user, orphan:orphan);
                  Navigator.of(context).pushReplacementNamed('Memberentry',arguments: {'user':user,'orphanslist':orphanlst});
                }
            )),
          SizedBox(
            height: height/20
          )
          ],
        )
       );

  }



}


