import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projects/screens/contact_form.dart';
import 'package:projects/screens/contacts_list.dart';
import 'package:projects/screens/dashboard.dart';

import 'database/app_database.dart';
import 'models/contact.dart';

void main() {
  runApp(ByteBankApp());
    findAll().then((contacts) => debugPrint(contacts.toString()));
}

class ByteBankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.green[900],
          accentColor: Colors.blueAccent[700],
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.blueAccent[700],
            textTheme: ButtonTextTheme.primary,
          )),
      home: DashBoard(),
    );
  }
}
