import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class RouteHandler {
  static var cookieJar;
  static final dio = Dio();
  static bool started = false;
  static const defaultHost = "http://10.0.2.2:8000";
  //static const defaultHost = "https://issapp.gabrielmalek.com/";

  static init() async {
    if (started) return;
    await setUpCookieJar();
    dio.interceptors.add(CookieManager(RouteHandler.cookieJar));
    dio.options.connectTimeout = const Duration(seconds: 30);
    started = true;
    checkForExpiredCookies();
    //check if cookies are expired
  }

  static setUpCookieJar() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    RouteHandler.cookieJar = PersistCookieJar(
      storage: FileStorage("$appDocPath/.cookies/"),
    );
  }

  //deletes cookies if expired
  static void checkForExpiredCookies() async {
    DateTime now = DateTime.now();
    //TODO: check for expired cookies
    String endPoint = '/login';
    var url = '$defaultHost$endPoint';
    List<Cookie> cookies = await cookieJar.loadForRequest(Uri.parse(url));
    for (var cookie in cookies) {
      var decoded = Uri.decodeFull(cookie.value);
      //replace + with spaces
      decoded = decoded.replaceAll("+", " ");
      var cookieObject = json.decode(decoded);
      if (cookieObject['expires'] == null) continue;
      DateTime expiresTime = DateFormat('EEE, dd MMM yyyy HH:mm:ss \'GMT\'')
          .parseUtc(cookieObject['expires'].toString());
      if (now.isAfter(expiresTime)) {
        await cookieJar.delete(Uri.parse(url));
      }
    }
  }

  //clears cookies
  static void clearCookies() async {
    await cookieJar.deleteAll();
  }
}
