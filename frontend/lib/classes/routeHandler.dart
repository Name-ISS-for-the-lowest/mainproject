import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';

class RouteHandler {
  static final cookieJar = CookieJar();
  static final dio = Dio();
  static bool started = false;
  static const defaultHost = "http://10.0.2.2:8000";

  static void init() {
    if (started) return;
    dio.interceptors.add(CookieManager(cookieJar));
    dio.options.connectTimeout = const Duration(seconds: 30);
    started = true;
  }
}
