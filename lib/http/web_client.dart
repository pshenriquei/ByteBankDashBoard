import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

import 'interceptors/loggin_interceptor.dart';

final Client client = InterceptedClient.build(
  interceptors: [LoggingInterceptor()],
);

const String baseUrl = 'ba38a119e725.ngrok.io';
const String baseUrlRepositorio = 'transactions';