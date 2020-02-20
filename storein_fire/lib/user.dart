import 'package:cloud_firestore/cloud_firestore.dart';


class User {
  final String name;
  final int age;
  final DocumentReference reference;

  User({this.name, this.age, this.reference});

  User.fromMap(Map<String, dynamic> map, {this.reference}) :
    // return User(name: map['name'], age: map['age']);
    name = map['name'],
    age = map['age']; 

  User.fromSnapshot(DocumentSnapshot snapshot) :
    this.fromMap(snapshot.data, reference: snapshot.reference);
}