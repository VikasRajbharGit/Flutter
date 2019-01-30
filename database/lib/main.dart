import 'package:database/models/user.dart';
import 'package:database/utils/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

List Users;

void main() async {
  var db = new DatabaseHelper();
  // Map userMap={
  //   "username":"Vikas",
  //   "password":"vikas123"
  // };
  await db.SaveUser(User("Pankaj", "pankaj420"));
  await db.SaveUser(User("Nishant", "nishant69"));
  
  Users=await db.getAllUsers();
  print(Users);

  runApp(new MaterialApp(
    title: "Database",
    home: new Home(),
  ));
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Database"),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Container(
        child: ListView.builder(
          itemCount:Users.length ,
          itemBuilder: (_, int position){
            return Card(
              elevation: 5.0,
              child: ListTile(
                leading: CircleAvatar(child: Text((position+1).toString()),),
                title: Text("User: ${User.fromMap(Users[position]).username}"),
                subtitle:Text("User: ${User.fromMap(Users[position]).id}") ,
                onTap:()=> debugPrint("password: ${User.fromMap(Users[position]).password}"),
              ) ,
            );
          },
        )
      )
    );
  }

}
