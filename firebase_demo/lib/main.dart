import 'package:firebase_demo/firebase_connect.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
            Icon(Icons.person_add),
            Text('Sign In with Google')
          ],),
          onPressed: () => gSignIn(),
        ),
      ),
    );
  }

  Future<FirebaseUser> gSignIn() async {
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    // FirebaseUser user = await _auth.signInWithGoogle(idToken:googleSignInAuthentication.idToken,
    // accessToken:googleSignInAuthentication.accessToken);

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    final FirebaseUser user = await _auth.signInWithCredential(credential);
    print("signed in " + user.displayName);
    if(user!=null){
      Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => firebase_setup(user.uid,_googleSignIn)),
  );
    }

    return user;

  }
}
