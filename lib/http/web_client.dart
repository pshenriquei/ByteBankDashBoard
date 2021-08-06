import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';

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

void findAll() async {
  final http.Client client = InterceptedClient.build(interceptors: [
    LoggingInterceptor(),
  ]);
  Uri uri = Uri.http('192.168.0.105:8080', 'transactions');
  http.Response response = await client.get(uri);
}
