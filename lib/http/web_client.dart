import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

import 'interceptors/loggin_interceptor.dart';

final Client client = InterceptedClient.build(
  interceptors: [LoggingInterceptor()],
  requestTimeout: Duration(seconds: 5),
);

const String baseUrl = '191d-2804-14d-5c42-4ba9-21cc-f905-2fcc-6dae.ngrok.io';
const String baseUrlRepositorio = 'transactions';
