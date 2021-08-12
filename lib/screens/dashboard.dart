import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projects/screens/contacts_list.dart';
import 'package:projects/screens/transactions_list.dart';

const _titleAppBarDashBoard = 'DashBoard';
const _titleBtTransfer = 'Transfer';
const _titleBtTransactionFeed = 'Transaction Feed';

class DashBoard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titleAppBarDashBoard),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('images/bytebank_logo.png'),
          ),
          Container(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _FeatureItem(
                  _titleBtTransfer,
                  Icons.monetization_on,
                  onClick: () => _showContactsList(context),
                ),
                _FeatureItem(
                  _titleBtTransactionFeed,
                  Icons.description,
                  onClick: () => _showTrancactionList(context),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _showContactsList(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ContactsList(),
      ),
    );
  }

  _showTrancactionList(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TransactionsList(),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final String name;
  final IconData icon;
  final Function? onClick;

  _FeatureItem(
    this.name,
    this.icon, {
    @required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Theme.of(context).primaryColor,
        child: InkWell(
          onTap: () => onClick!(),
          child: Container(
            padding: EdgeInsets.all(8.0),
            width: 160,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 24.0,
                ),
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
