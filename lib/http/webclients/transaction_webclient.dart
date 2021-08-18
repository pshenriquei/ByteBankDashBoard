import 'dart:convert';

import 'package:http/http.dart';
import 'package:projects/http/web_client.dart';
import 'package:projects/models/transaction.dart';

final Uri uri = Uri.http(baseUrl, baseUrlRepositorio);

class TransactionWebClient {
  Future<List<Transaction>> findAll() async {
    final Response response = await client.get(uri);
    final List<dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson
        .map((dynamic json) => Transaction.fromJson(json))
        .toList();
  }

  Future<Transaction?> save(Transaction transaction, String password) async {
    final String transactionJson = jsonEncode(transaction.toJson());
    
    final Response? response = await client.post(uri,
      headers: {
        'Content-type': 'application/json',
        'password': password,
      },
      body: transactionJson,);

    if (response!.statusCode == 200) {
      return Transaction.fromJson(jsonDecode(response.body));
    }
    throw HttpException(_getMessage(response.statusCode));
  }

  String _getMessage(int statusCode) {
    if(_statusCodeResponse.containsKey(statusCode)){
      return _statusCodeResponse[statusCode]!;
    }
    return 'Unknown Error!';
  }

  static final Map<int, String> _statusCodeResponse = {
    400: 'There was an error submitting transaction',
    401: 'Authentication Failed',
    409: "Transaction already exists",
  };
}

class HttpException implements Exception {
  final String message;

  HttpException(this.message);

}
