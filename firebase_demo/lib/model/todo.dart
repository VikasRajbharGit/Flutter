import 'package:firebase_database/firebase_database.dart';
class Todo{
  String key;
  String title;
  String description;

  Todo(this.title,this.description);

  Todo.fromSnapshot(DataSnapshot snapshot):
    key=snapshot.key,
    title=snapshot.value['title'],
    description=snapshot.value['description'];

  toJson(){
    return{
      'title':title,
      'description':description
    };
  }

}