import 'package:flutter/material.dart';
import 'package:flutter_crud_database/models/user.dart';
import 'package:flutter_crud_database/utils/database_helper.dart';

List _users;

void main() async {
  var db = new DatabaseHelper();

  // Create user

//  await db.saveUser(User("Gerard", "loyc"));
  // Get all users
  _users = await db.getAllUsers();

  for (int i = 0; i < _users.length; i++) {
    User user = User.map(_users[i]);

    print("Username: ${user.username}");
  }

  runApp(MaterialApp(
    title: "DATABASE",
    home: new Home(),
  ));
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Database'),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: _users.length,
          itemBuilder: (_, int position) {
            return Card(
                color: Colors.white,
                elevation: 2.0,
                child: ListTile(
                  leading: CircleAvatar(
                      child: Text(
                          "${User.map(_users[position]).username.substring(0, 1)}")),
                  title: Text("User: ${User.map(_users[position]).username}"),
                  subtitle: Text("Id: ${User.map(_users[position]).id}"),
                  onTap: () =>
                      debugPrint("${User.map(_users[position]).password}"),
                ));
          }),
    );
  }
}
