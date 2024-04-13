// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_full_hex_values_for_flutter_colors


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:todoapp/services/database.dart';

class Home extends StatefulWidget {
const Home({super.key});

@override
State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
bool today = true, tommorow = false, nextweek = false;
bool suggest = false;
Stream ? todoStream;

getontheload() async {
  DatabaseMethods databaseMethods = DatabaseMethods(); // Create an instance of DatabaseMethods
  todoStream = await databaseMethods.getalltheWork(
    today ? "Today" : tommorow ? "Tommorow" : "NextWeek"
  );
  setState(() {
    // Update the UI or do something with todoStream
  });
}

@override
  void initState() {
    getontheload();
    super.initState();
  }
Widget allWork(){
  return StreamBuilder(stream:todoStream,builder:(context , AsyncSnapshot snapshot){
return snapshot.hasData? ListView.builder(
  scrollDirection: Axis.vertical,
        shrinkWrap: true,
  padding:EdgeInsets.zero,
 itemCount:snapshot.data.docs.length,
  itemBuilder: (context, index){
  DocumentSnapshot ds= snapshot.data.docs[index];
  return CheckboxListTile(
activeColor: Colors.blue,
title: Text(
ds["Work"],
style: TextStyle(
color: Colors.white,
fontSize: 25,
fontWeight: FontWeight.w400),
),
// value: suggest,
value: ds["Yes"],
onChanged: (newValue)async {
  await DatabaseMethods().updateifTicked(ds["Id"],today ? "Today" : tommorow ? "Tommorow" : "NextWeek");
setState(() {


});
},
controlAffinity: ListTileControlAffinity.leading,
);
}):CircularProgressIndicator();
  });
}

TextEditingController todoController = TextEditingController();
@override
Widget build(BuildContext context) {
return Scaffold(
floatingActionButton: FloatingActionButton(
onPressed: () {
  openBox();
},
child    : Icon(
Icons.add,
color: Colors.blue,
size: 30.0,
),
),
body: Container(
padding: EdgeInsets.only(top: 90.0, left: 30.0),
height: MediaQuery.of(context).size.height,
width: MediaQuery.of(context).size.width,
decoration: BoxDecoration(
gradient: LinearGradient(colors: [
Color(0xff232fda2),
Color(0xFF13D8CA),
Color(0xFF09adfe)
], begin: Alignment.topLeft, end: Alignment.bottomRight)),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
"HELLO\nHIMANSHU",
style: TextStyle(
color: Colors.white,
fontSize: 25.0,
fontWeight: FontWeight.bold),
),
SizedBox(
height: 10,
),
Text(
"GOOD MORNING",
style: TextStyle(
color: Colors.white,
fontSize: 20.0,
fontWeight: FontWeight.w300),
),
SizedBox(
height: 10,
),
Row(
mainAxisAlignment: MainAxisAlignment.spaceEvenly,
children: [
today
? Material(
elevation: 5.0,
borderRadius: BorderRadius.circular(20),
child: Container(
padding: EdgeInsets.symmetric(
horizontal: 20, vertical: 5.0),
decoration: BoxDecoration(
color: Color(0xFF3dffe3),
borderRadius: BorderRadius.circular(20)),
child: Text(
"Today",
style: TextStyle(
color: Colors.white,
fontSize: 20,
fontWeight: FontWeight.bold),
),
),
)
: GestureDetector(
onTap: () async {
today = true;
tommorow = false;
nextweek = false;
await getontheload();
setState(() {});
},
child: Text("Today",
style: TextStyle(
color: Colors.white,
fontSize: 18,
fontWeight: FontWeight.bold)),
),
tommorow
? Material(
elevation: 5.0,
borderRadius: BorderRadius.circular(20),
child: Container(
padding: EdgeInsets.symmetric(
horizontal: 20, vertical: 5.0),
decoration: BoxDecoration(
color: Color(0xFF3dffe3),
borderRadius: BorderRadius.circular(20)),
child: Text(
"Tommorow",
style: TextStyle(
color: Colors.white,
fontSize: 20,
fontWeight: FontWeight.bold),
),
),
)
: GestureDetector(
onTap: () async {
today = false;
tommorow = true;
nextweek = false;
await getontheload();
setState(() {});
},
child: Text("Tommorow",
style: TextStyle(
color: Colors.white,
fontSize: 18,
fontWeight: FontWeight.bold)),
),
// for next week
nextweek
? Material(
elevation: 5.0,
borderRadius: BorderRadius.circular(20),
child: Container(
padding: EdgeInsets.symmetric(
horizontal: 20, vertical: 5.0),
decoration: BoxDecoration(
color: Color(0xFF3dffe3),
borderRadius: BorderRadius.circular(20)),
child: Text(
"Next Week",
style: TextStyle(
color: Colors.white,
fontSize: 20,
fontWeight: FontWeight.bold),
),
),
)
: GestureDetector(
onTap: () async {
today = false;
tommorow = false;
nextweek = true;
await getontheload();
setState(() {});
},
child: Text("Next Week",
style: TextStyle(
color: Colors.white,
fontSize: 18,
fontWeight: FontWeight.bold)),
),
],
),
// check box ka code likha hai yha pe
SizedBox(
height: 20.0,
),
allWork(),
],
),
),
);
}

// yha se humne logic likha hai code ka

Future openBox() => showDialog(
context: context,
builder: ((context) => AlertDialog(
content: SingleChildScrollView(
child: Container(
child: Column(
children: [
GestureDetector(
onTap: () {
Navigator.pop(context);
},
child: Icon(Icons.cancel)),
SizedBox(
width: 60,
),
Text(
"Add the work ToDo",
style: TextStyle(
color: Colors.black, fontWeight: FontWeight.bold),
),
SizedBox(
height: 20,
),
Text("Add Text"),
SizedBox(
height: 10,
),
Container(
padding: EdgeInsets.symmetric(horizontal: 10.0),
decoration: BoxDecoration(
border: Border.all(
color: Colors.black38,
width: 2.0,
),
borderRadius: BorderRadius.circular(10)),
child: TextField(
controller: todoController,
decoration: InputDecoration(
border: InputBorder.none, hintText: "Enter Text"),
),
),
SizedBox(
height: 20.0,
),

// 3eeno funtion ka code yha likha h today, tommorrow and next week ka

GestureDetector(
  onTap:(){
   String id=randomAlphaNumeric(10);
   Map<String, dynamic> userTodo={
    "Work": todoController.text,
    "Id" : id,
    "Yes":false,
   };
   today? DatabaseMethods().addTodayWork(userTodo, id):
   tommorow ? DatabaseMethods().addTommorowWork(userTodo, id):
   DatabaseMethods().addNextWeekWork(userTodo, id);
   Navigator.pop(context);
  } ,
  child: Center(
  child: Container(
  width: 100,
  padding: EdgeInsets.all(5),
  decoration: BoxDecoration(
  color: Color(0xFF008080),
  borderRadius: BorderRadius.circular(10)),
  child: Center(
  child: Text(
  "Add",
  style: TextStyle(color: Colors.white),
  ),
  ),
  ),
  ),
)
],
)),
),
)));
}
