import 'package:firebase_app/models/user.dart';
import 'package:firebase_app/screens/authentication/authentication.dart';
import 'package:firebase_app/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    if (user == null) {
      return Authentication();
    } else {
      return Home();
    }
  }
}
