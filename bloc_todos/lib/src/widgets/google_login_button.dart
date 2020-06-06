import 'package:bloc_todos/src/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/bloc.dart';

class SignInWithGoogleButton extends StatelessWidget {
  final FirebaseUserRepository _userRepository;
  SignInWithGoogleButton(this._userRepository);
        
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc,LoginState>(
      listener: (context,state){
      if(state is LogInError){
        Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('Login Failure'), Icon(Icons.error)],
                ),
                backgroundColor: Colors.red,
              ),
            );
      }
      else if(state is LoggingIn){
        Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Logging In...'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
      }
      else if(state is LogInSuccess){
        BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
      }
    },
    child: BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Material(
          borderRadius: BorderRadius.circular(10),
          color: Colors.orange,
          child: InkWell(child: Container(
            padding: EdgeInsets.fromLTRB(70, 20, 70,20),
            child: Text('SignIn with Google',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),)),
          onTap: (){BlocProvider.of<LoginBloc>(context).add(SignInWithGooglePressed());},
          splashColor: Colors.orangeAccent
          
          
          
          ),
        );
      },
    ),
    );
  }
}
