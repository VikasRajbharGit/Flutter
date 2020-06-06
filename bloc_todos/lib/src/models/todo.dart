import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Todo extends Equatable{
  final bool complete;
  final String id;
  final String note;
  final String task;

  Todo(this.task, {this.complete = false, String note = '', String id,})
      : this.note = note ?? '',
        this.id = id;

  Todo copyWith({bool complete, String id, String note, String task}) {
    return Todo(
      task ?? this.task,
      complete: complete ?? this.complete,
      id: id ?? this.id,
      note: note ?? this.note,
    );
  }

  @override
  List<Object> get props => [complete,id,note,task];

  Todo.fromSnapshot(Map data):
  complete=data['complete'],
  id=data['id'],
  note=data['note'],
  task=data['task'];

  toJson(){
    return {
      'complete':complete,
      'id':id,
      'note':note,
      'task':task
    };
  }
}