import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class DatabaseMethods{
  Future addTodayWork(Map<String, dynamic>userTodayMap, String id)async{
    return await FirebaseFirestore.instance.collection("Today").doc(id).set(userTodayMap);

  }

  Future addTommorowWork(Map<String, dynamic>userTodayMap, String id)async{
    return await FirebaseFirestore.instance.collection("tommorow").doc(id).set(userTodayMap);

  }

  Future addNextWeekWork(Map<String, dynamic>userTodayMap, String id)async{
    return await FirebaseFirestore.instance.collection("NextWeek").doc(id).set(userTodayMap);

  }

//yha paas hum data ko fetch kr rhe hai
Future <Stream<QuerySnapshot>> getalltheWork(String day)async{
  return await FirebaseFirestore.instance.collection(day).snapshots();
}

// jb hum tick par click karenge

updateifTicked(String id, String day)async{
  return await FirebaseFirestore.instance.collection(
    day).doc(id).update({"Yes": true});
}

}

