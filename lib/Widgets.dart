import 'dart:ffi';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Widgets {
  // This widget is the root of your application.

  Widget carousalslider(BuildContext context, var height, var width,String type)
  {
    return
      ListView( 
          children: [
            CarouselSlider(
                items:
                [
                  Container(
                      height: height/4,
                      width: width,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image:AssetImage('assets/ca1.jpg'),
                              fit: BoxFit.cover
                          )
                      ),

                  ),
                  Container(
                      height: height/4,
                      width: width,
                      padding: EdgeInsets.all(40.0),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image:AssetImage('assets/ca2.jpg'),
                              fit: BoxFit.cover
                          )
                      ),
                  ),
                  Container(
                    height: height/4,
                    width: width,
                    padding: EdgeInsets.all(40.0),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image:AssetImage('assets/ca3.jpg'),
                            fit: BoxFit.cover
                        )
                    ),
                  )
                ],
                options:
                CarouselOptions(
                  height:height/4,
                  enlargeCenterPage: false,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  viewportFraction: 1,
                  enableInfiniteScroll: true,
                )
            )
          ]
      );
  }

  Widget orphanslst(BuildContext context, var height, var width,String type,var orphans)
  {


    var adoptedby = [];
    var reportedby = [];

    if(type=='Member')
    {
       orphans.forEach((k, v) => adoptedby.add(v));}

    else
    {
       orphans.forEach((k, v) => reportedby.add(v));}

    var orphanname = orphans.keys.toList();

    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
          Image( image: AssetImage('assets/img.png')),
          Column(
            children: [
              type=='Member'?Text('Below are the list of orphans reported...', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),):
              Text('Below are the list of orphans adopted...', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
              SizedBox(
                height: 30
              ),
              Container(
                  child:
                  ListView.builder(
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                          leading: Icon(Icons.account_box_rounded),
                          trailing: type=='Member'?Text(adoptedby[index]):Text(reportedby[index]),
                          title:Text(orphanname[index].split(',')[0]),
                          onTap: (){ Navigator.pushNamed(context,'Orphan',arguments: {'id':orphanname[index]});}
                      );
                    },
                    shrinkWrap: true,
                  )
              )
            ],
          )
      ],
    );
  }

  Widget profiledata(BuildContext context, var height, var width,String type,var details_map)
  {
    var name = details_map["name"];
    var identity = details_map['contact'];
    var state = details_map['state'];
    var orphans = type=='Member'?details_map['orphansreported']:details_map['orphansadopted'];

    print('profile data obtained');

    return //Text('Profile data available $name $identity $state $orphans',style: TextStyle(color: Colors.amber));
      Column(
      children:[
        Expanded( child: Stack(
            alignment: AlignmentDirectional.center,
          children:[
              Image( image: AssetImage('assets/back.png'),height: height/4),
              Positioned( child:Text(name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)), top:height/6),
              Positioned(child: Icon(Icons.person,size: 70,color: Colors.white),top:height/16)
            ]
        )),
        SizedBox(
          height: 20,
        ),

        Center( child:Stack(
            alignment: AlignmentDirectional.center,
            children:[
              Container( child:Image( image: AssetImage('assets/back_bo.png')),height: height/8, width: 9*width/10),
              Text(identity, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white))
            ]
        )),
        SizedBox(
          height: 15,
        ),

        Center( child:Stack(
            alignment: AlignmentDirectional.center,
            children:[
            Container( child:Image( image: AssetImage('assets/back_bo.png')),height: height/8, width: 9*width/10),
              Text(state, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white))
            ]
        )),
        SizedBox(
          height: 15,
        ),

        Center( child: Stack(
            alignment: AlignmentDirectional.center,
            children:[
              Container( child:Image( image: AssetImage('assets/back_bo.png')),height: height/8, width: 9*width/10),
              Text('orphans reported: $orphans', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white))
            ]
        )),
        SizedBox(
          height: 15,
        ),

        Container(
            //margin: EdgeInsets.all(20),
            height: 25,
            child: ElevatedButton(
              onPressed: (){
                Navigator.of(context).pushReplacementNamed('Login');

              },
              child:  Text('Log Out'),
            )
        ),
        SizedBox(
          height: 20,
        )
      ]

    );
  }




  void showsnackbar(String text,BuildContext context)
  {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  }


