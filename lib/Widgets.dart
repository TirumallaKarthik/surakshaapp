import 'dart:ffi';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Widgets {


  Widget carousalslider(BuildContext context, var height, var width, var images) {

    return CarouselSlider(
                items:
                [
                  Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: images[0],
                            fit: BoxFit.fitHeight
                        )
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: images[1],
                            fit: BoxFit.fitHeight
                        )
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: images[2],
                            fit: BoxFit.fitHeight
                        )
                    ),
                  )
                ],
                options:
                CarouselOptions(
                  height: height / 4,
                  enlargeCenterPage: false,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  viewportFraction: 1,
                  enableInfiniteScroll: true,
                )
            );
  }


  Widget orphanslst(BuildContext context, var height, var width, String type, var orphans) {
    //var adoptedby = [];
    var reportedby = [];

    orphans.forEach((k, v) => reportedby.add(v));

    return Stack(
      alignment: AlignmentDirectional.topStart,
      children: [
        Image(image: AssetImage('assets/img.png')),
        ListView.builder(
                  itemCount: reportedby.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                        leading: Icon(Icons.account_box_rounded),
                        trailing: Text(reportedby[index]["adoptedby"]),
                        title: Text(reportedby[index]["orphanname"]),
                        onTap: () {

                        }
                    );
                  },
                  shrinkWrap: true,
                )
        ]
    );
  }


  Widget profiledata(BuildContext context, double height, double width, var details_map) {
    var name = details_map['name'];
    var identity = details_map['identity'];
    var state = details_map['state'];
    var orphans = details_map['orphans'];

    print('profile data obtained');

    return //Text('Profile data available $name $identity $state $orphans',style: TextStyle(color: Colors.amber));
      Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Image(
                      image: AssetImage('assets/back.png'), height: height / 4),
                  Positioned(child: Text(name, style: TextStyle(fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)), top: height / 6),
                  Positioned(
                      child: Icon(Icons.person, size: 70, color: Colors.white),
                      top: height / 16)
                ]
            )),

            Center(child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Container(
                      child: Image(image: AssetImage('assets/back_bo.png')),
                      height: height / 8,
                      width: 9 * width / 10),
                  Text(identity, style: TextStyle(fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white))
                ]
            )),

            Center(child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Container(
                      child: Image(image: AssetImage('assets/back_bo.png')),
                      height: height / 8,
                      width: 9 * width / 10),
                  Text(state, style: TextStyle(fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white))
                ]
            )),

            Center(child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Container(
                      child: Image(image: AssetImage('assets/back_bo.png')),
                      height: height / 8,
                      width: 9 * width / 10),
                  Text('orphans reported : $orphans', style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white))
                ]
            )),

            Container(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('Login');
                  },
                  child: Text('Log Out'),
                )
            ),
            SizedBox(
              height: height/10,
            )
          ]

      );
  }

  Widget container(double height, double width, EdgeInsets padding, Widget child, BoxDecoration dec)
  {
     return Container(
       height: height,
       width: width,
       padding: padding,
       child: child,
       decoration: dec
     );
  }

  Widget text(String value,String font,double size, FontWeight weight, Color color)
  {
    return Text(value,style: TextStyle(fontFamily: font,fontSize: size,fontWeight: weight,color: color));
  }


  Widget sizedbox(double height,double width)
  {
    return SizedBox(
      height: height
    );
  }

  Widget textfield(TextInputType inputType, String label, String hint, BorderRadius radius, TextEditingController cntrl)
  {
    return TextField(
      keyboardType: inputType,
      decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(
              borderRadius: radius
          )
      ),
      controller: cntrl
    );
  }


  void showsnackbar(String text, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

}

