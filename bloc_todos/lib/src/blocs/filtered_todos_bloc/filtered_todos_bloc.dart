import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_todos/src/blocs/bloc.dart';
import 'package:bloc_todos/src/models/models.dart';
import 'package:bloc_todos/src/models/visibility_filter.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'filtered_todos_event.dart';
part 'filtered_todos_state.dart';

class FilteredTodosBloc extends Bloc<FilteredTodosEvent, FilteredTodosState> {
  final TodosBloc todosBloc;
  StreamSubscription todosSubscription;

  FilteredTodosBloc({@required this.todosBloc}) {
    todosSubscription = todosBloc.listen((state) {
      if (state is TodosLoaded) {
        add(TodosUpdated((todosBloc.state as TodosLoaded).todos));
      }
    });
  }

  @override
  FilteredTodosState get initialState => FilteredTodosLoading();

  @override
  Stream<FilteredTodosState> mapEventToState(
    FilteredTodosEvent event,
  ) async* {
    if (event is FilterPressed) {
     yield* _mapFilterPressedToState(event);
    } else if (event is TodosUpdated) {
     yield* _mapTodosUpdatedToState(event);
    }
  }

  List<Todo> _mapTodosToFilteredTodos(
      List<Todo> todos, VisibilityFilter filter) {
    try{
      return todos.where((todo) {
      if (filter == VisibilityFilter.all) {
        return true;
      } else if (filter == VisibilityFilter.active) {
        return !todo.complete;
      } else {
        return todo.complete;
      }
    }).toList();
    }
    catch(e){
      return[];
    }
  }

  Stream<FilteredTodosState> _mapFilterPressedToState(event) async* {
    try {
      if (todosBloc.state is TodosLoaded) {
        yield FilteredTodosLoaded(
          _mapTodosToFilteredTodos(
            (todosBloc.state as TodosLoaded).todos,
            event.filter,
          ),
          event.filter,
        );
      }
    } catch (e) {
      yield FilteredTodosFailed();
    }
  }

  Stream<FilteredTodosState> _mapTodosUpdatedToState(event) async* {
    final visibilityFilter = state is FilteredTodosLoaded
        ? (state as FilteredTodosLoaded).activeFilter
        : VisibilityFilter.all;
    yield FilteredTodosLoaded(
      _mapTodosToFilteredTodos(
        (todosBloc.state as TodosLoaded).todos,
        visibilityFilter,
      ),
      visibilityFilter,
    );
  }

  @override
  Future<void> close() {
    todosSubscription.cancel();
    return super.close();
  }
}
