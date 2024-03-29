
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:surakshaapp/DBObject.dart';
import 'package:surakshaapp/templates/Builders.dart';


class Orphanprofile extends StatelessWidget {


  ///////////////////////////////variables used
  late var height;
  late var width;
  late Orphanobject orphanobject;


  //////////////////////base

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    Map args = ModalRoute.of(context)!.settings.arguments as Map;
    orphanobject = args['orphan'];

    return Center(
        child:
        ListView(
            children:[
              SizedBox(height: height/10,width: width,),
              Center( child: Stack(
                  alignment: AlignmentDirectional.topCenter,
                  children:[
                    Image( image: AssetImage('assets/back.png'),height: height/3),
                    Positioned(child:Container(height:height/3, width:width/3, padding:EdgeInsets.zero, child:Image.network(orphanobject.imageurl.toString())),top:height/300),
                    Positioned( child:TextBuilder(orphanobject.name,'JosefinSans',20.0,FontWeight.bold,Colors.white).builder(), top:height/50)
                  ]
              )),
              SizedBox(height: height/15 ),
              Center( child:Stack(
                  alignment: AlignmentDirectional.center,
                  children:[
                    Container( child:Image( image: AssetImage('assets/back_bo.png')),height: height/8, width: 9*width/10),
                    TextBuilder('Age: '+orphanobject.age.toString(),'JosefinSans',16.0,FontWeight.bold,Colors.white).builder()
                  ]
              )),
              SizedBox(height: height/15 ),
              Center( child:Stack(
                  alignment: AlignmentDirectional.center,
                  children:[
                    Container( child:Image( image: AssetImage('assets/back_bo.png')),height: height/8, width: 9*width/10),
                    TextBuilder('Coordinates: '+orphanobject.coordinates,'JosefinSans',12.0,FontWeight.bold,Colors.white).builder()
                  ]
              )),
              SizedBox(height: height/15 ),
              Center( child: Stack(
                  alignment: AlignmentDirectional.center,
                  children:[
                    Container( child:Image( image: AssetImage('assets/back_bo.png')),height: height/8, width: 9*width/10),
                    TextBuilder('Adoptedby: '+orphanobject.adoptedby,'JosefinSans',16.0,FontWeight.bold,Colors.white).builder()
                  ]
              )),
              SizedBox(height: height/15 ),
              Center( child: Stack(
                  alignment: AlignmentDirectional.center,
                  children:[
                    Container( child:Image( image: AssetImage('assets/back_bo.png')),height: height/8, width: 9*width/10),
                    TextBuilder('Reportedby: '+orphanobject.reportedby,'JosefinSans',16.0,FontWeight.bold,Colors.white).builder()
                  ]
              )),
              SizedBox(height: height/10)
            ]

        )
    );
  }
    ////////////////////widgets


}






