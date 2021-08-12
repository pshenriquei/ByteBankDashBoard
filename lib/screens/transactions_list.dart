import 'package:flutter/material.dart';
import 'package:projects/components/centered_message.dart';
import 'package:projects/components/progress.dart';
import 'package:projects/http/web_client.dart';
import 'package:projects/models/transaction.dart';

const _titleAppBarTransactions = 'Transactions';
const _error = 'Unknown error';

class TransactionsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titleAppBarTransactions),
      ),
      body: FutureBuilder<List<Transaction>>(
          future: findAll(),
          builder: (context, snapshot) {

            switch (snapshot.connectionState) {
              case ConnectionState.none:
                break;

              case ConnectionState.waiting:
                return Progress();

              case ConnectionState.active:
                break;

              case ConnectionState.done:

                if(snapshot.hasData){
                  final List<Transaction>? transactions = snapshot.data;
                  if (transactions!.isNotEmpty){
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        final Transaction transaction = transactions[index];
                        return Card(
                          child: ListTile(
                            leading: Icon(Icons.monetization_on),
                            title: Text(
                              'Valor transferido:'+ transaction.value.toString(),
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'Conta destino:' + transaction.contact.accountNumber.toString(),
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: transactions.length,
                    );
                  }
                }
                  return CenteredMessage(
                    'No transactions Found',
                    icon: Icons.warning,
                  );
            }
            return CenteredMessage(
              _error,
              icon: Icons.error);
          },
      ),
    );
  }
}
