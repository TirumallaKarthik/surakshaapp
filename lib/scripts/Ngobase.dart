
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:surakshaapp/widgets.dart';

class Ngoentry extends StatefulWidget {

  @override
  _entryState createState() => _entryState();
}

class _entryState extends State<Ngoentry> {
  var height;
  var width;
  int selected=0;
  var name;
  var emailid;
  var orp_adop;
  var state;
  var orphans;
  TextEditingController namecon = new TextEditingController();
  TextEditingController statecon = new TextEditingController();
  //////////////////functions

  Future<Widget> checkfirst(var mailid,BuildContext context) async
  {


    await FirebaseFirestore.instance.collection('ngos').doc(mailid).get().then(
            (document) async
        {
          if(!document.exists) {
            //get details
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
                  child: Container(
                    height: height/2,
                    width: width/2,

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Fill up', style: TextStyle(color: Colors.green)),
                        SizedBox(
                          height: height/10,
                        ),
                        TextField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              labelText: 'Name',
                              hintText: 'Enter full name of ngo',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50)
                              )
                          ),
                          controller: namecon,
                        ),
                        SizedBox(
                          height: height/10,
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
                        TextButton(onPressed: () {

                          Navigator.of(context).pop();
                        },
                            child: Text('Go', style: TextStyle(color: Colors.purple, fontSize: 18.0),))
                      ],
                    ),
                  ),
                );
              },
            );

            //upload to firebase
            await FirebaseFirestore.instance.collection('ngos').doc(mailid).set(
                {
                  'name':namecon.text,
                  'state':statecon.text,
                  'orphans_adop':0
                });
            name = namecon.text;
            state= statecon.text;
            orp_adop = 0;
            orphans = null;

          }else{
            setState(() {

              name = document.data()!['name'];
              state = document.data()!['state'];
              orp_adop = document.data()!['orphans_adop'];
              orphans = document = document.data()!['orphans'];
            });

          }

        }
    );



    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(backgroundColor: Colors.black38, title:Text('Hi $name')),
        backgroundColor: Colors.black87,
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: (){
              Navigator.of(context).pushNamed('Tag',arguments: {'mail':mailid});
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
        selected == 0? home(context):(selected == 1?search(context):profile(context))

    );

  }

  ///////////////////base
  @override
  Widget build(BuildContext context) {

    //get passed arguments
    Map args = ModalRoute.of(context)!.settings.arguments as Map;
    emailid = args['mailid'];


    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Container(
        child:
        FutureBuilder<dynamic>(
            builder: (context, snapshot){
              if(snapshot.hasData)
              { return snapshot.data;}

              return Center(child: CircularProgressIndicator());
            },
            future: checkfirst(emailid,context)
        )
    );

  }

  ///////////////////widgets

  Widget home(BuildContext context){
    var obj = Widgets();

    return Column(
        children: [
          Expanded(child: obj.carousalslider(context, height, width, 'Ngo')),
          obj.orphanslst(context, height, width,'Ngo',orphans)
        ]
    );
  }
  Widget search(BuildContext context){
    return Text('search',style: TextStyle(color: Colors.amber));
  }
  Widget profile(BuildContext context){
    var obj = Widgets();
    var details = {
      'name':name,
      'state':state,
      'contact':emailid,
      'orphansadopted':orp_adop
    };
    return obj.profiledata(context, height, width,'Ngo',details);
  }

}