part of 'stats_bloc.dart';

abstract class StatsEvent extends Equatable {
  const StatsEvent();
  @override
  List<Object> get props => [];
}

class StatsPressed extends StatsEvent {
  final List<Todo> todos;

  const StatsPressed(this.todos);

  @override
  List<Object> get props => [todos];

  @override
  String toString() => 'StatsPressed { todos: $todos }';
}
