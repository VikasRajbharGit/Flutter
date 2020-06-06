import 'package:equatable/equatable.dart';

class User extends Equatable{
  final String displayName;
  final String uid;

  User({this.displayName, this.uid});

  

  toJson(){
    return {
      'displayName':displayName,
      'uid':uid,
    };
  }

  @override
  List<Object> get props => [displayName,uid];
}