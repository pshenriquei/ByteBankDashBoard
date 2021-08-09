import 'dart:convert';

import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:projects/models/contact.dart';
import 'package:projects/models/transaction.dart';

class LoggingInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    print('Request');
    print('url: ${data.url}');
    print('headers: ${data.headers}');
    print('body: ${data.body}');
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    print('Response');
    print('Status Code: ${data.statusCode}');
    print('headers: ${data.headers}');
    print('body: ${data.body}');
    return data;
  }
}
final Client client = InterceptedClient.build(
  interceptors: [LoggingInterceptor()],
);

const String baseUrl = 'ea59cf76160c.ngrok.io';
const String baseUrlRepositorio = 'transactions';

Future<List<Transaction>> findAll() async {
  Uri uri = Uri.http(baseUrl, baseUrlRepositorio);
  Response response = await client
      .get(uri)
      .timeout(Duration(seconds: 5));
  final List<dynamic> decodedJson = jsonDecode(response.body);
  final List<Transaction> transactions = [];
  for (Map<String, dynamic> transactionJson in decodedJson) {
    final Map<String, dynamic> contactJson = transactionJson['contact'];
    final Transaction transaction = Transaction(
      transactionJson['value'],
      Contact(
        0,
        contactJson['name'],
        contactJson['accountNumber'],
      ),
    );
    transactions.add(transaction);
  }
  return transactions;
}

Future<Transaction> save(Transaction transaction) async {

  final Map<String, dynamic> transactionMap = {
    'value': transaction.value,
    'contact':{
      'name': transaction.contact.name,
      'accountNumber': transaction.contact.accountNumber,
    }
  };
  final String transactionJson = jsonEncode(transactionMap);

  Uri uri = Uri.http(baseUrl, baseUrlRepositorio);
  final Response response =  await client.post(uri, headers: {
    'Content-type': 'application/json',
    'password': '1000',
  },
      body: transactionJson);

  Map<String,dynamic> json = jsonDecode(response.body);
  final Map<String, dynamic> contactJson = json['contact'];
  return Transaction(
    json['value'],
    Contact(
      0,
      contactJson['name'],
      contactJson['accountNumber'],
    ),
  );
}
