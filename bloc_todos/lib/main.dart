import 'package:bloc_todos/src/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:bloc_todos/src/blocs/bloc.dart';
import 'package:bloc_todos/src/firestore_todos_repository.dart';
import 'package:bloc_todos/src/models/visibility_filter.dart';
import 'package:bloc_todos/src/screens/home_screen.dart';
import 'package:bloc_todos/src/screens/login_screen.dart';
import 'package:bloc_todos/src/screens/splash_screen.dart';
import 'package:bloc_todos/src/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'src/blocs/bloc_delegate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  FirebaseUser user= await FirebaseAuth.instance.currentUser();
  final FirebaseUserRepository _userRepository = FirebaseUserRepository();
  runApp(BlocProvider(
    create: (context) =>
        AuthenticationBloc(userRepository: _userRepository)..add(AppStarted()),
    child: App(_userRepository),
  ));
}

class App extends StatelessWidget {
  final FirebaseUserRepository _userRepository;
  App(this._userRepository);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
        if (state is UnInitialized) {
          return SplashScreen();
        } else if (state is Authenticated) {
          return Center(
            child: MultiBlocProvider(
                providers: [
                  BlocProvider<TodosBloc>(
                    create: (context) {
                      final todoCollection = Firestore.instance
                          .collection('${state.user.uid}/todos/todos');
                      final FirestoreTodosRepository _todosRepository =
                          FirestoreTodosRepository(
                              todoCollection: todoCollection);
                      return TodosBloc(todosRepository: _todosRepository)
                        ..add(LoadTodos());
                    },
                  ),
                  BlocProvider<TabsBloc>(
                    create: (context) => TabsBloc(),
                  ),
                  // BlocProvider(
                  //   create: (context) => FilteredTodosBloc(
                  //       todosBloc: BlocProvider.of<TodosBloc>(context)),
                  // ),
                ],
                child: HomeScreen(
                  user: state.user,
                )),
          );
        } else if (state is Unauthenticated) {
          return LoginScreen(
            userRepository: _userRepository,
          );
        }
      }),
    );
  }
}
