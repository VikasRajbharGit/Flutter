import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_todos/src/models/user.dart';
import 'package:bloc_todos/src/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final FirebaseUserRepository _userRepository;

  AuthenticationBloc({@required FirebaseUserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;
  @override
  AuthenticationState get initialState => UnInitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    try {
      final isSignedIn = await _userRepository.isAuthenticated();
      if (!isSignedIn) {
        yield Unauthenticated();
      }
      final User user = await _userRepository.getUser();
      yield Authenticated(user:user);
    } catch (e) {
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState()async*{
    final User user=await _userRepository.getUser();
    yield Authenticated(user: user);
  }

  Stream<AuthenticationState> _mapLoggedOutToState()async*{
    yield Unauthenticated();
    _userRepository.signOut();
  }
}
