import 'package:bloc_todos/src/blocs/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class Stats extends StatelessWidget {
  Stats({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>StatsBloc(todosBloc: BlocProvider.of<TodosBloc>(context)),
      child: BlocBuilder<StatsBloc, StatsState>(
        builder: (context, state) {
          if (state is StatsPressed) {
            return CircularProgressIndicator();
          } else if (state is StatsLoaded) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Completed Todos',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 24.0),
                    child: Text(
                      '${state.numCompleted}',
                      
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Active Todos',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 24.0),
                    child: Text(
                      "${state.numActive}",
                      
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  )
                ],
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
