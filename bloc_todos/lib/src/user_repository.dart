import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'models/user.dart';

abstract class UserRepository{
Future<bool> isAuthenticated();
Future<void> authenticate();
Future<User> getUser();
Future<FirebaseUser> signInWithGoogle();
Future<void> signOut();
}

class FirebaseUserRepository implements UserRepository{
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  
  FirebaseUserRepository({FirebaseAuth firebaseAuth,GoogleSignIn googleSignin})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
      _googleSignIn = googleSignin ?? GoogleSignIn();

  @override
  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await _firebaseAuth.signInWithCredential(credential);
    return _firebaseAuth.currentUser();
  }
  @override
  Future<void> authenticate() {
    return _firebaseAuth.signInAnonymously();
    
  }

  @override
  Future<User> getUser() async {
    FirebaseUser user=await _firebaseAuth.currentUser();
    return User(displayName: user.displayName,uid: user.uid);
  }

  @override
  Future<bool> isAuthenticated() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  @override
  Future<void> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

}