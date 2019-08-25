import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'model/todo.dart';

class firebase_setup extends StatefulWidget {
  String uid;
  GoogleSignIn _googleSignIn = new GoogleSignIn();
  firebase_setup(this.uid,this._googleSignIn);
  @override
  _firebase_setupState createState() => _firebase_setupState(uid,_googleSignIn);
}

class _firebase_setupState extends State<firebase_setup> {
  String id;
  var snap;
  final db= Firestore.instance;
  GoogleSignIn _googleSignIn = new GoogleSignIn();
  String uid;
  _firebase_setupState(this.uid,this._googleSignIn);
  List<Todo> todos = List();
  Todo todo;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  onSubmit() {}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    todo = Todo('', '');
   // databaseReference = database.reference().child('Todos');
    //databaseReference.onChildAdded.listen(onDataAdded);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todos'),
        actions: <Widget>[
          RaisedButton(
            child: Icon(Icons.arrow_back),
            onPressed: () {gSignOut();},
          ),
        ],
      ),
      body: Column(children: [
        Form(
          key: formKey,
          child: Flex(
            direction: Axis.vertical,
            children: <Widget>[
              TextFormField(
                initialValue: '',
                onSaved: (val) => todo.title = val,
                validator: (val) => val == '' ? val : null,
              ),
              TextFormField(
                initialValue: '',
                onSaved: (val) => todo.description = val,
                validator: (val) => val == '' ? val : null,
              ),
              FlatButton(
                child: Text('Post'),
                onPressed: () {
                  handleSubmit();
                },
              )
            ],
          ),
        ),
        Container(
          height: 200.0,
          width: 200.0,
          child: StreamBuilder<QuerySnapshot>(
            stream: db.collection(uid).snapshots(),
            builder: (_,snapshot){
              if(snapshot.hasData){
                print(snapshot.data.documents);

                snap=snapshot.data.documents.asMap();
                print(snap[2].data['title']);
                print('lenght:::: ${snap.length}');
                print(snap);
//                return Column(children: snapshot.data.documents.map((doc){
//                  return Card(child: ListTile(
//                    title: Text(doc.data['title'].toString()),
//                    subtitle: Text(doc.data['description'].toString()),
//                  ),);
//                }).toList());

              return GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                  itemBuilder: (_,index){
//                  return Card(
//
//                    child: Text(snap[index].data['title'].toString()),
//                  );
                  return Card(
                    child: ListTile(
                      title: Text(snap[index].data['title']),
                      subtitle: Text(snap[index].data['description']),
                    ),
                  );
                  },
                itemCount: snap.length,
              );

              }
              else{
                return SizedBox(width: 5.0,height: 5.0,);
              }
            },
          ),
        ),
      
      ]),
    );
  }



  void handleSubmit() async {
    final FormState form = formKey.currentState;
    if (form.validate()) {
      form.save();


      DocumentReference ref=await db.collection(uid).add(todo.toJson());
      form.reset();
      setState(() {
       id=ref.documentID; 
      });

      //databaseReference.push().set(todo.toJson());
    }
  }

  gSignOut() async{
    await FirebaseAuth.instance.signOut();
    await _googleSignIn.signOut();
    Navigator.pop(context);

  }
}
