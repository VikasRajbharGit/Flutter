part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();
  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoggingIn extends LoginState {}

class LogInSuccess extends LoginState {
  final User user;
  LogInSuccess({this.user});

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'LoggedIn { displayName: ${user.displayName} }';
}

class LogInError extends LoginState {
  final String error;
  LogInError(this.error);
  @override
  String toString() => 'Error: $error';
}
