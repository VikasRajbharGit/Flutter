import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'models/models.dart';

abstract class TodosRepository {
  Future<void> addNewTodo(Todo todo);
  Future<void> deleteTodo(Todo todo);
  Stream<List<Todo>> todos();
  Future<void> updateTodo(Todo update);
}

class FirestoreTodosRepository implements TodosRepository {
  final CollectionReference todoCollection;

  FirestoreTodosRepository({@required CollectionReference todoCollection}):this.todoCollection=todoCollection;

  @override
  Future<void> addNewTodo(Todo todo) {
    return todoCollection.document(todo.id).setData(todo.toJson());
  }

  @override
  Future<void> deleteTodo(Todo todo) {
    return todoCollection.document(todo.id).delete();
  }

  @override
  Stream<List<Todo>> todos() {
    return todoCollection.snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => Todo.fromSnapshot(doc.data))
          .toList();
    });
  }

  @override
  Future<void> updateTodo(Todo update) {
    return todoCollection.document(update.id).updateData(update.toJson());
  }
}
