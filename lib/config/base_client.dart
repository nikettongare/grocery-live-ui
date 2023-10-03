import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class BaseClient {
  static const int reqTimeoutDuration = 20;

  Future<dynamic> get(String url) async {
    var uri = Uri.parse(url);
    dynamic _responseData;

    try {
      var _response = await http
          .get(uri)
          .timeout(const Duration(seconds: reqTimeoutDuration));
      _responseData = jsonDecode(_response.body);

      if (_responseData['success']) {
        return _responseData['data'];
      } else {
        return Future.error(_responseData['data']);
      }
    } on SocketException {
      return Future.error("No Internet Connection.");
    } on TimeoutException {
      return Future.error("Server Timeout.");
    }
  }

  Future<dynamic> post({required String url, required Map payload}) async {
    var uri = Uri.parse(url);

    Map<String, String> _header = {"Content-Type": "application/json"};
    var _body = jsonEncode(payload);

    dynamic _responseData;

    try {
      var _response = await http
          .post(uri, headers: _header, body: _body)
          .timeout(const Duration(seconds: reqTimeoutDuration));

      _responseData = jsonDecode(_response.body);

      if (_responseData['success']) {
        return _responseData['data'];
      } else {
        return Future.error(_responseData['data']);
      }
    } on SocketException {
      return Future.error("No Internet Connection.");
    } on TimeoutException {
      return Future.error("Server Timeout.");
    }
  }
}
