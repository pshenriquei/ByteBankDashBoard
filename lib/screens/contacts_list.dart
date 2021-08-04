import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projects/models/contact.dart';
import 'package:projects/screens/contact_form.dart';

class ContactsList extends StatelessWidget {

  final List<Contact> contacts = [];

  @override
  Widget build(BuildContext context) {
    contacts.add(Contact(0, 'Pedro', 1000));
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index){
          final Contact contact = contacts[index];
          return _ContactItem(contact);
        },
        itemCount: contacts.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (context) => ContactForm(),
                ),
              )
              .then(
                (newContact) => debugPrint(newContact.toString()),
              );
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}

class _ContactItem extends StatelessWidget{

  final Contact contact;
  _ContactItem(this.contact);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          "Name: " + contact.name,
          style: TextStyle(fontSize: 24.0),
        ),
        subtitle: Text(
          "Number Account: " + contact.accountNumber.toString(),
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}