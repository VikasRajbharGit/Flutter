import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_todos/src/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../bloc.dart';

part 'stats_event.dart';
part 'stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  final TodosBloc todosBloc;
  StreamSubscription todosSubscription;

  StatsBloc({@required this.todosBloc}) {
    todosSubscription = todosBloc.listen((state) {
      if (state is TodosLoaded) {
        add(StatsPressed(state.todos));
      }
    });
  }
  @override
  StatsState get initialState => StatsLoading();

  @override
  Stream<StatsState> mapEventToState(
    StatsEvent event,
  ) async* {
    if(event is StatsPressed){
     yield* _mapStatsPressedToState(event);
    }
  }

 Stream<StatsState> _mapStatsPressedToState(event)async*{
    int active=event.todos.where((todo)=>todo.complete==false).toList().length;
    int complete=event.todos.where((todo)=>todo.complete==true).toList().length;
    yield StatsLoaded(active, complete);
  }

   @override
  Future<void> close() {
    todosSubscription.cancel();
    return super.close();
  }

}
