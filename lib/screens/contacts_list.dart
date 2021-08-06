import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projects/database/dao/contact_dao.dart';
import 'package:projects/models/contact.dart';
import 'package:projects/screens/contact_form.dart';

const _titleAppBarTransfer = 'Transfer';
const _loading = 'Loading...';
const _error = 'Unknown error';

class ContactsList extends StatefulWidget {
  @override
  _ContactsListState createState() => _ContactsListState();
}

final ContactDao _dao = ContactDao();

class _ContactsListState extends State<ContactsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titleAppBarTransfer),
      ),
      body: FutureBuilder<List<Contact>>(
        initialData: [],
        future: _dao.findAll(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;

            case ConnectionState.waiting:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Text(_loading),
                  ],
                ),
              );

            case ConnectionState.active:
              break;

            case ConnectionState.done:
              final List<Contact>? contacts = snapshot.data as List<Contact>;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final Contact contact = contacts![index];
                  return _ContactItem(contact);
                },
                itemCount: contacts!.length,
              );
          }
          return Text(_error);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (context) => ContactForm(),
                ),
              )
              .then((value) => {setState(() {})});
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
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
