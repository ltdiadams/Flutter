import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user.dart';

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

// final users = [
// User(name: 'kyle', age: 27), 
// User(name: 'adri', age: 34), 
// User(name: 'andy', age: 13)
// ];

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final _usersReference = Firestore.instance.collection('users');

  final _nameController = TextEditingController();
  final _ageController = TextEditingController();

  String _name = '';
  int _age = 0;

  Widget _buildDialog() {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width - 40,
        height: 250,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name'
                    ),
                  ),
                  TextField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Age'
                    ),
                  ),
                ],
              ),
              FlatButton(
                child: Text('Save'),
                color: Colors.blue,
                onPressed: () {
                  final Map<String, dynamic> userMap = {'name': _nameController.text, 'age': int.parse(_ageController.text)};
                  _usersReference.add(userMap);
                  _nameController.text = '';
                  _ageController.text = '';
                  // _nameController.dispose();
                  // _ageController.dispose();
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    return FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => _buildDialog()
        ),
        tooltip: 'Increment',
        child: Icon(Icons.add),
    );
  }

  Widget _buildUserTile(User user) {
    return ListTile(
      title: Text(user.name),
      subtitle: Text('age: ${user.age}'),
    );
  }
  
  Widget _buildListView(List<DocumentSnapshot> documents) {
    return ListView.builder(
      itemCount: documents.length,
      itemBuilder: (_, i) => _buildUserTile(User.fromSnapshot(documents[i])),
    );
  }

  Widget _buildUsersStream() {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersReference.snapshots(),
      builder: (_, snapshot){
        if (snapshot.hasData) {
          return _buildListView(snapshot.data.documents);
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _buildUsersStream(),
      floatingActionButton: _buildActionButton(),
    );
  }
}
