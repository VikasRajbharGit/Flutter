import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_todos/src/models/user.dart';
import 'package:bloc_todos/src/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  FirebaseUserRepository _userRepository;
  LoginBloc({@required FirebaseUserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;
  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is SignInWithGooglePressed) {
      yield* _mapSignInWithGooglePressedToState();
    }
  }

  Stream<LoginState> _mapSignInWithGooglePressedToState() async* {
    try{
      yield LoggingIn();
      await _userRepository.signInWithGoogle();
      User user=await _userRepository.getUser();
      yield LogInSuccess(user: user);
    }
    catch(e){
      yield LogInError(e.toString());
    }
  }
}
