part of 'filtered_todos_bloc.dart';

abstract class FilteredTodosState extends Equatable {
  const FilteredTodosState();
  @override
  List<Object> get props => [];
}

class FilteredTodosLoading extends FilteredTodosState {
  
}

class FilteredTodosLoaded extends FilteredTodosState {
  final List<Todo> filteredTodos;
  final VisibilityFilter activeFilter;
  FilteredTodosLoaded(this.filteredTodos,this.activeFilter);
   @override
  List<Object> get props => [filteredTodos, activeFilter];

  @override
  String toString() {
    return 'FilteredTodosLoadSuccess { filteredTodos: $filteredTodos, activeFilter: $activeFilter }';
  }
}

class FilteredTodosFailed extends FilteredTodosState {}