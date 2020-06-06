part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
  @override
  List<Object> get props => [];
}

class UnInitialized extends AuthenticationState {}

class Authenticated extends AuthenticationState {
  final User user;
  const Authenticated({@required User user})
      : assert(user != null),
        user = user;

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'Authenticated { displayName: ${user.displayName}';
}

class Unauthenticated extends AuthenticationState {}
