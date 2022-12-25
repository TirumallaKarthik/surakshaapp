import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:surakshaapp/DBObject.dart';

class Firestore {
  static void updatedocument(String collection,String id,{String? count, String? userid,String? username}) async {
    if(collection == 'orphan') {
      await FirebaseFirestore.instance.collection(collection).doc(id).update(
          {'adoptedby': username, 'adoptedid': userid}).then((value) {
        debugPrint('orphan data updated');
      });
    }
    else if(collection == 'member'){
      await FirebaseFirestore.instance.collection(collection).doc(id).update(
          {'orphans_reported': count}).then((value) {
        debugPrint('orphan count modified');
      });
    }
    else if(collection == 'ngo'){
      await FirebaseFirestore.instance.collection(collection).doc(id).update(
          {'orphans_adopted': count}).then((value) {
        debugPrint('orphan count modified');
      });
    }
  }

  static Future<dynamic> insertdocument(String collection,var obj,[String? userid]) async{
    late var ref;
    if (userid != null) {
      Map<String, dynamic> data = {
        'name': obj.name,
        'age': obj.age.toString(),
        'description': obj.description,
        'coordinates': obj.coordinates,
        'adoptedby': 'Not Yet',
        'reportedby': obj.reportedby,
        'imageurl': obj.imageurl,
        'adoptedid': 'Not Yet',
        'reportedid': userid
      };
      ref = await FirebaseFirestore.instance.collection(collection).add(data).then((
          value) {
        debugPrint('orphan data added');
      });

    }
  else {
      Map<String, dynamic> udata = collection=='member'?{
        'name': obj.name,
        'state': obj.state,
        'orphans_reported': 0,
        'phonenumber': obj.phonenumber
      }:{
        'name': obj.name,
        'state': obj.state,
        'orphans_adopted': 0,
        'mailid': obj.mailid
      };
      ref = await FirebaseFirestore.instance.collection(collection).add(udata).then((
          value) {
        debugPrint('user data added');
      });
    }
    return ref.documentID;

  }

  static Future<dynamic> getdocument(String collection,String id) async {
      late var user;
      await (FirebaseFirestore.instance.collection(collection).doc(id).get().then(
          (document) {
              if (!document.exists)
                {
                  return [];
                }
              Map<String,dynamic> doc = document.data()!;
              debugPrint('firestore document ${id} user ${collection} data ${doc.toString()}');

              if(collection=='member'){
                  user = Memberobject(doc['name'],doc['state'],int.parse(doc['orphans_reported']),doc['phonenumber']);
                  debugPrint('collection is member ${user.toString()}');
              }else if(collection == 'ngo'){
                  user = Ngoobject(doc['name'],doc['state'],int.parse(doc['orphans_adopted']),doc['mailid']);
                  debugPrint('collection is ngo ${user.toString()}');
              }
              else{
                  user = [Orphanobject(doc['name'],int.parse(doc['age']),doc['description'],doc['coordinates'],doc['adoptedby'],doc['reportedby'],doc['imageurl']),doc['reportedid']];
                  debugPrint('collection is orphan ${user.toString()}');
              }
          }
      ));

      return user;
  }

  static Future<dynamic> getorphandocumentsbyuser(var user) async {
          List<Orphanobject> lst=[];
          if(user.type == 'member'){
              debugPrint('get orphan documents for member ${user.phonenumber}');
              await FirebaseFirestore.instance.collection('orphan').where('reportedid',isEqualTo:user.phonenumber).get().then(
                      (event){
                    debugPrint('snapshot data ${event.docs.single}');
                    for(int i=0;i<event.size;i++)
                    {
                      lst.add(Orphanobject(event.docs[i]['name'], int.parse(event.docs[i]['age']), event.docs[i]['description'], event.docs[i]['coordinates'], event.docs[i]['adoptedby'], event.docs[i]['reportedby'], event.docs[i]['imageurl']));
                    }
                    debugPrint('orphans list ${lst.toString()}');
                  });
          }
          else{
              debugPrint('get orphan documents for ngo ${user.mailid}');
              await FirebaseFirestore.instance.collection('orphan').where('adoptedid',isEqualTo: user.mailid).get().then(
                      (event) {
                    debugPrint('size ${event.size}');
                    for(int i=0;i<event.size;i++)
                    {
                      lst.add(Orphanobject(event.docs[i]['name'], int.parse(event.docs[i]['age']), event.docs[i]['description'], event.docs[i]['coordinates'], event.docs[i]['adoptedby'], event.docs[i]['reportedby'], event.docs[i]['imageurl']));
                    }
                    debugPrint('orphans list ${lst.toString()}');
                  });
          }
          return lst;
    }

    static Future<dynamic> getcontact (var user) async {
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