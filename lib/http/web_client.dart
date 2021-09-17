import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

import 'interceptors/loggin_interceptor.dart';

final Client client = InterceptedClient.build(
  interceptors: [LoggingInterceptor()],
  requestTimeout: Duration(seconds: 5),
);

const String baseUrl = '4b98-2804-14d-5c42-4c5b-a5aa-f5f5-a834-2f3d.ngrok.io';
const String baseUrlRepositorio = 'transactions';