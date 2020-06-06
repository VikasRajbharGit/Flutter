import 'package:bloc_todos/src/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:bloc_todos/src/blocs/bloc.dart';
import 'package:bloc_todos/src/models/models.dart';
import 'package:bloc_todos/src/models/user.dart';
import 'package:bloc_todos/src/screens/add_edit_screen.dart';
import 'package:bloc_todos/src/widgets/extra_actions.dart';
import 'package:bloc_todos/src/widgets/filter_button.dart';
import 'package:bloc_todos/src/widgets/filtered_todos.dart';
import 'package:bloc_todos/src/widgets/stats.dart';
import 'package:bloc_todos/src/widgets/tab_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  final User user;

  HomeScreen({Key key, @required this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabsBloc, AppTab>(builder: (context, state) {
      return BlocProvider(
        create: (context) =>
            FilteredTodosBloc(todosBloc: BlocProvider.of<TodosBloc>(context)),
        child: Scaffold(
          appBar: AppBar(
            title: state == AppTab.todos ? Text('Todos') : Text('Stats'),
            actions: <Widget>[
              FilterButton(visible: state == AppTab.todos),
              ExtraActions(),
              IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () {
                  BlocProvider.of<AuthenticationBloc>(context).add(
                    LoggedOut(),
                  );
                },
              )
            ],
          ),
          body:
              state == AppTab.todos ? Center(child: FilteredTodos()) : Stats(),
          bottomNavigationBar: TabSelector(
            activeTab: state,
            onTabPressed: (tab) =>
                BlocProvider.of<TabsBloc>(context).add(TabUpdated(tab)),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => AddEditScreen(
                          onSave: (task, note) {
                            BlocProvider.of<TodosBloc>(context).add(TodoAdded(
                                todo: Todo(task,
                                    note: note,
                                    id: DateTime.now()
                                        .millisecondsSinceEpoch
                                        .toString())));
                          },
                          isEditing: false)));
            },
            child: Icon(Icons.add),
            tooltip: 'Add Todo',
          ),
        ),
      );
    });
  }
}
