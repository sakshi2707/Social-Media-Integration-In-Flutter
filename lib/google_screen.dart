import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Animation/FadeAnimation.dart';
import 'google_auth.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Social Media Integration",
        ),
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection("users").snapshots(),
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              DocumentSnapshot user = snapshot.data.documents[index];
              return Column(
                children: <Widget>[
                  Card(
                    child: Container(
                        width: 120,
                        height: 120,
                        color: Colors.grey,
                        child: Image.network(
                          user['photoURL'],
                          fit: BoxFit.fill,
                        )),
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    elevation: 5,
                    margin: EdgeInsets.all(10),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Name: ${user['displayName']}\nEmail: ${user['email']}',
                      style: TextStyle(
                          fontSize: 30.0,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  MaterialButton(
                    child: Text('Logout'),
                    onPressed: () => authService.signOut(),
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }
}
