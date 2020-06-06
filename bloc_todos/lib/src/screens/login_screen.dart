import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../user_repository.dart';
import '../widgets/google_login_button.dart';
import '../blocs/bloc.dart';

class LoginScreen extends StatelessWidget {
  final FirebaseUserRepository _userRepository;

  LoginScreen({Key key, @required FirebaseUserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(create: (context){
      return LoginBloc(userRepository: _userRepository);
    },
    child: Scaffold(
          body: Center(
          child:SignInWithGoogleButton(_userRepository)
        ),
    ),);
  }
}