import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
//import 'package:quake/main.dart';
import "package:intl/intl.dart";

class Quake extends StatefulWidget {
  var _quakes;
   Quake(Map data){
     this._quakes=data;
  }
  @override
  State<StatefulWidget> createState() {
    return new QuakeState(_quakes);
  }
}

class QuakeState extends State<Quake> {
  var _quakes;
  QuakeState(Map data){
    this._quakes=data;
  }
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Quaked"),
      ),
      body: Center(
        child: ListView.builder(
            itemCount: _quakes["features"].length,
            itemBuilder: (BuildContext context, int position) {
              return Column(
                children: <Widget>[
                  Divider(
                    height: 10.0,
                  ),
                  ListTile(
                    title: Text(convertDate(position,_quakes)),
                    subtitle:Text(_quakes["features"][position]["properties"]["place"]) ,
                    leading: CircleAvatar(child: Text(_quakes["features"][position]["properties"]["mag"].toString(),)),
                    onTap:()=> _showOnTap(context, "Mag:${_quakes["features"][position]["properties"]["mag"].toString()}---${_quakes["features"][position]["properties"]["place"]}"),
                  )
                ],
              );
            }),
      ),
    );
  }
}

Future<Map> getJson() async {
  String url =
      "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson";
  http.Response response = await http.get(url);
  return json.decode(response.body);
}

String convertDate(int position,Map _quakes) {
  //print(data);
  DateTime date = new DateTime.fromMillisecondsSinceEpoch(
      _quakes["features"][position]["properties"]["time"],isUtc: true);
  var format = new DateFormat.yMMMMd("en_US").add_jm();
  String dateString = format.format(date);
  return dateString;
}
void _showOnTap(BuildContext context,String message){
  var alert=AlertDialog(
    title: new Text("Quake"),
    content: Text(message),
    actions: <Widget>[
      FlatButton(
        child:Text("OK"),
        onPressed:(){
          Navigator.pop(context);
        }
      )
    ],
    
  );
  showDialog(context:context,builder: (context)=>alert);
}