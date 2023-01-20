import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:surakshaapp/DBObject.dart';

class Firestore {

  static void updatedoc(String collection, String id, Map<String,dynamic> updatedata) async {
    await FirebaseFirestore.instance.collection(collection).doc(id).update(
        updatedata).then((value) {
      debugPrint('data updated');
    });
  }

  static Future<dynamic> insertdoc(String collection,var data) async {

     var id;
     await FirebaseFirestore.instance.collection(collection).add(data).then((
         value) {
       debugPrint('data added');
       id = value.id;
     });

     return id;
  }

  static Future<dynamic> getdoc(String collection,String id) async {
      late var user;
      await FirebaseFirestore.instance.collection(collection).doc(id).get().then(
          (document) {
              if (!document.exists)
                {
                  return null;
                }
              Map<String,dynamic> doc = document.data()!;
              debugPrint('firestore document ${id} user ${collection} data ${doc.toString()}');
              return doc;
          }
      );

  }

  static Future<dynamic> getorphandoc(var user,String key,String val) async {
          List<Orphanobject> lst=[];

          debugPrint('get orphan documents');
          await FirebaseFirestore.instance.collection('orphan').where(key,isEqualTo:val).get().then(
                  (event){
                debugPrint('snapshot data ${event.toString()}');
                for(int i=0;i<event.size;i++)
                {
                  lst.add(Orphanobject(event.docs[i]['name'], int.parse(event.docs[i]['age']), event.docs[i]['description'], event.docs[i]['coordinates'], event.docs[i]['adoptedby'], event.docs[i]['reportedby'], event.docs[i]['imageurl']));
                }
                debugPrint('orphans list ${lst.toString()}');
              });

          return lst;
  }

  static Future<dynamic> getngomailids (var user) async {
      List<String> contactlst=[];
      if(user.type == 'member'){
        debugPrint('entered as member');
        await FirebaseFirestore.instance.collection('ngo').get().then(
                (value){
                  debugPrint('snapshot data ${value.size}');
                  for(int i=0;i<value.size;i++)
                    {
                      contactlst.add(value.docs[i].data()['mailid']);
                    }
                });
      }
      return contactlst;
    }

}