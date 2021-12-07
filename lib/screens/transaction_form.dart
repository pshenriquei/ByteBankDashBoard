import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects/components/container.dart';
import 'package:projects/components/error.dart';
import 'package:projects/components/progress.dart';
import 'package:projects/components/response_dialog.dart';
import 'package:projects/components/transaction_auth_dialog.dart';
import 'package:projects/http/webclients/transaction_webclient.dart';
import 'package:projects/models/contact.dart';
import 'package:projects/models/transaction.dart';
import 'package:uuid/uuid.dart';

@immutable
abstract class TransactionFormState {
  const TransactionFormState();
}

@immutable
class SendingState extends TransactionFormState {
  const SendingState();
}

@immutable
class ShowFormState extends TransactionFormState {
  const ShowFormState();
}

@immutable
class SentState extends TransactionFormState {
  const SentState();
}

@immutable
class FatalErrorFormState extends TransactionFormState {
  final String _message;

  const FatalErrorFormState(this._message);
}

class TransactionFormCubit extends Cubit<TransactionFormState> {
  TransactionFormCubit() : super(ShowFormState());

  void save(Transaction transactionCreated, String password,
      BuildContext context) async {
    emit(SendingState());
    await _send(
      transactionCreated,
      password,
      context,
    );
  }

  _send(Transaction transactionCreated, String password,
      BuildContext context) async {
    await TransactionWebClient()
        .save(transactionCreated, password)
        .then((transaction) => emit(SentState()))
        .catchError((e) {
      emit(FatalErrorFormState(e.message));

      FirebaseCrashlytics.instance.setCustomKey('Exception', e.toString());
      FirebaseCrashlytics.instance
          .setCustomKey('Http_body', transactionCreated.toString());
      FirebaseCrashlytics.instance.recordError(e, null);
    }, test: (e) => e is HttpException).catchError((e) {
      emit(FatalErrorFormState('Timeout submitting the transaction'));

      FirebaseCrashlytics.instance.setCustomKey('Exception', e.toString());
      FirebaseCrashlytics.instance.setCustomKey('Htpp_code', e.statusCode);
      FirebaseCrashlytics.instance
          .setCustomKey('Http_body', transactionCreated.toString());
      FirebaseCrashlytics.instance.recordError(e, null);
    }, test: (e) => e is TimeoutException).catchError(
      (e) {
        emit(FatalErrorFormState(e.message));

        FirebaseCrashlytics.instance.setCustomKey('Exception', e.toString());
        FirebaseCrashlytics.instance
            .setCustomKey('Http_body', transactionCreated.toString());
        FirebaseCrashlytics.instance.recordError(e, null);
      },
    );
  }
}

class TransactionFormContainer extends BlocContainer {
  final Contact _contact;

  TransactionFormContainer(this._contact);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TransactionFormCubit>(
      create: (BuildContext context) {
        return TransactionFormCubit();
      },
      child: BlocListener<TransactionFormCubit, TransactionFormState>(
          listener: (context, state) {
            if (state is SentState) {
              Navigator.pop(context);
            }
          },
          child: TransactionFormStateless(_contact)),
    );
  }
}

class TransactionFormStateless extends StatelessWidget {
  final Contact _contact;

  TransactionFormStateless(this._contact);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionFormCubit, TransactionFormState>(
      builder: (context, state) {
        if (state is ShowFormState) {
          return _BasicForm(_contact);
        }
        if (state is SendingState || state is SentState) {
          return ProgressView();
        }
        if (state is FatalErrorFormState) {
          return ErrorView(state._message);
        }
        return ErrorView("Unknown error");
      },
    );
  }

  Future<void> _showSucessfulMessage(
      Transaction transaction, BuildContext context) async {
    if (transaction != null) {
      await showDialog(
          context: context,
          builder: (contextDialog) {
            return SuccessDialog('Sucessful Transaction');
          });
      Navigator.pop(context);
    }
  }

  void _showFailureMessage(
    BuildContext context, {
    String message = 'Unknown Error',
  }) {
    showDialog(
        context: context,
        builder: (contextDialog) {
          return FailureDialog(message);
        });
  }
}

class _BasicForm extends StatelessWidget {
  final Contact _contact;
  final TextEditingController _valueController = TextEditingController();
  final String transactionId = Uuid().v4();

  _BasicForm(this._contact);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New transaction'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _contact.name,
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  _contact.accountNumber.toString(),
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: _valueController,
                  style: TextStyle(fontSize: 24.0),
                  decoration: InputDecoration(labelText: 'Value'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    child: Text('Transfer'),
                    onPressed: () {
                      final double value =
                          double.tryParse(_valueController.text) ?? 0;
                      final transactionCreated = Transaction(
                        value,
                        _contact,
                        transactionId,
                      );
                      showDialog(
                          context: context,
                          builder: (contextDialog) {
                            return TransactionAuthDialog(
                              onConfirm: (String password) {
                                BlocProvider.of<TransactionFormCubit>(context)
                                    .save(
                                        transactionCreated, password, context);
                              },
                            );
                          });
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
