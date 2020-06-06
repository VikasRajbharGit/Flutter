import 'package:bloc_todos/src/blocs/bloc.dart';
import 'package:bloc_todos/src/models/models.dart';
import 'package:bloc_todos/src/screens/detail_screen.dart';
import 'package:bloc_todos/src/widgets/todo_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'deleted_todo_snackbar.dart';

class FilteredTodos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilteredTodosBloc, FilteredTodosState>(
      builder: (context, state) {
        if (state is FilteredTodosLoading) {
          return Center(child: CircularProgressIndicator());
        }
        else if(state is FilteredTodosLoaded){
          List<Todo> todos=state.filteredTodos;
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (_,index){
              final todo=todos[index];
              return TodoItem(onDismissed: (direction){
                BlocProvider.of<TodosBloc>(context).add(TodoDeleted(todo:todo));
                  Scaffold.of(context).showSnackBar(DeleteTodoSnackBar(
                    
                    todo: todo,
                    onUndo: () =>
                        BlocProvider.of<TodosBloc>(context).add(TodoAdded(todo:todo)),
                    
                  ));
              },
               onTap:() async {
                  final removedTodo = await Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) {
                      return DetailsScreen(id: todo.id,todosBloc:BlocProvider.of<TodosBloc>(context));
                    }),
                  );
                  if (removedTodo != null) {
                    Scaffold.of(context).showSnackBar(DeleteTodoSnackBar(
                      
                      todo: todo,
                      onUndo: () => BlocProvider.of<TodosBloc>(context)
                          .add(TodoAdded(todo:todo)),
                      
                    ));
                  }
                } ,
                onCheckboxChanged: (_) {
                  BlocProvider.of<TodosBloc>(context).add(
                    TodoUpdated(updatedTodo:todo.copyWith(complete: !todo.complete)),
                  );
                },
                todo: todo);
            }
          );
        }
        else if(state is FilteredTodosFailed){
          return Center(child: Text('Failed'));
        }
      },
    );
  }
}
