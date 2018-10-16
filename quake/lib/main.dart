import 'package:flutter/material.dart';
import './ui/quake.dart';
import 'dart:async';
Map data;
void main() async {
  data=await getJson();
  //print(data);
  runApp(new MaterialApp(
    title: "Quake",
    home: new Quake(data),
  ));
}