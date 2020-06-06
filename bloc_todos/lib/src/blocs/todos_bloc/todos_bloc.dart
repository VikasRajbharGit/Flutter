import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_todos/src/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../firestore_todos_repository.dart';

part 'todos_event.dart';
part 'todos_state.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  final FirestoreTodosRepository _todosRepository;
  StreamSubscription<List<Todo>> _todosSubscription;
  TodosBloc({@required FirestoreTodosRepository todosRepository})
      : _todosRepository = todosRepository;
  @override
  TodosState get initialState => TodosLoading();

  @override
  Stream<TodosState> mapEventToState(
    TodosEvent event,
  ) async* {
    if (event is LoadTodos) {
     yield* _mapLoadTodosToState();
    }
    else if(event is TodosLoadSuccessful){
      yield* _mapTodosLoadSuccessfulToState(event);
    }
    else if (event is TodoAdded) {
     yield* _mapTodoAddedToState(event);
    } else if (event is TodoUpdated) {
     yield* _mapTodoUpdatedToState(event);
    } else if (event is TodoDeleted) {
     yield* _mapTodoDeletedToState(event);
    } else if (event is ClearCompleted) {
     yield* _mapClearCompletedToState();
    } else if (event is ToggleAll) {
     yield* _mapToggleAllToState();
    }
  }

  Stream<TodosState> _mapLoadTodosToState() async* {
    
    try {
      _todosSubscription?.cancel();
      List<Todo> todos;
      _todosSubscription = _todosRepository.todos().listen((todosResult) {
        todos = todosResult;
        print(todos);
        add(TodosLoadSuccessful(todos:todosResult));
      });
      // yield TodosLoaded(todos: todos);
    } catch (e) {
      yield TodosError(error: e.toString());
    }
  }
  Stream<TodosState> _mapTodosLoadSuccessfulToState(event)async*{
    yield TodosLoaded(todos:event.todos);
  }
  Stream<TodosState> _mapTodoAddedToState(event) async* {
    try {
      _todosRepository.addNewTodo(event.todo);
      yield AlterTodoSuccess(msg: 'Todo Added');
      add(LoadTodos());
    } catch (e) {
      yield AlterTodoFail(msg: 'Todo Can not be Added');
      add(LoadTodos());
    }
  }

  Stream<TodosState> _mapTodoUpdatedToState(event) async* {
    try {
      //print('-------'+event.todo);
      _todosRepository.updateTodo(event.updatedTodo);
      yield AlterTodoSuccess(msg: 'Todo Updated');
      add(LoadTodos());
    } catch (e) {
      yield AlterTodoFail(msg: 'Todo Can not be Updated');
      add(LoadTodos());
    }
  }

  Stream<TodosState> _mapTodoDeletedToState(event) async* {
    try {
      _todosRepository.deleteTodo(event.todo);
      yield AlterTodoSuccess(msg: 'Todo Deleted');
      add(LoadTodos());
    } catch (e) {
      yield AlterTodoFail(msg: 'Todo Can not be Deleted');
      add(LoadTodos());
    }
  }

  Stream<TodosState> _mapClearCompletedToState() async* {
    final currentState = state;
    if (currentState is TodosLoaded) {
      final List<Todo> completedTodos =
          currentState.todos.where((todo) => todo.complete).toList();
      completedTodos.forEach((completedTodo) {
        _todosRepository.deleteTodo(completedTodo);
      });
    }
  }

  Stream<TodosState> _mapToggleAllToState() async* {
    final currentState = state;
    if (currentState is TodosLoaded) {
      final allComplete = currentState.todos.every((todo) => todo.complete);
      final List<Todo> updatedTodos = currentState.todos.map((todo) {
        return todo.copyWith(complete: !allComplete);
      }).toList();
      updatedTodos.forEach((updatedTodo) {
        _todosRepository.updateTodo(updatedTodo);
      });
    }
  }
}
