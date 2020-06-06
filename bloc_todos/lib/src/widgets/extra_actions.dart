import 'package:bloc_todos/src/blocs/bloc.dart';
import 'package:bloc_todos/src/models/extra_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExtraActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodosBloc,TodosState>(
      builder: (context,state){
        if(state is TodosLoaded){
          bool allComplete=state.todos.every((element) => element.complete==true);
          return PopupMenuButton<ExtraAction>(
          onSelected: (ExtraAction action){
            if(action==ExtraAction.toggleAllComplete){
              BlocProvider.of<TodosBloc>(context).add(ToggleAll());
            }
            else if(action==ExtraAction.clearCompleted){
              BlocProvider.of<TodosBloc>(context).add(ClearCompleted());
            }
          },
          itemBuilder: (context){
              return <PopupMenuItem<ExtraAction>>[PopupMenuItem<ExtraAction>(
                value: ExtraAction.toggleAllComplete,
                child: allComplete?Text('Mark all Incomplete'):Text('Mark all Complete'),
                ),
                PopupMenuItem<ExtraAction>(
                value: ExtraAction.clearCompleted,
                child: Text('Clear Completed'),
                )
                ];
          }
          );
        }
        else{
          return IgnorePointer(child: Container(height: 10,width:10),);
        }
      },
      
    );
  }
}