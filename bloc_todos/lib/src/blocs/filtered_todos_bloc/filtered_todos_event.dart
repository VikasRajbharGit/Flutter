part of 'filtered_todos_bloc.dart';

abstract class FilteredTodosEvent extends Equatable {
  const FilteredTodosEvent();
  @override
  List<Object> get props => [];

}

class FilterPressed extends FilteredTodosEvent{
  final VisibilityFilter filter;
  FilterPressed(this.filter);
  @override
  List<Object> get props => [filter];
   @override
  String toString() => 'FilterPressed { filter: $filter }';
}

class TodosUpdated extends FilteredTodosEvent {
  final List<Todo> todos;

  const TodosUpdated(this.todos);

  @override
  List<Object> get props => [todos];

  @override
  String toString() => 'TodosUpdated { todos: $todos }';
}
