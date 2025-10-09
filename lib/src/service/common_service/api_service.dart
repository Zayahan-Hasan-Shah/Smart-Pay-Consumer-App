import 'dart:convert';
import 'dart:developer';

import 'package:consumer_app/src/core/constants/key.dart';
import 'package:http/http.dart' as http;

import '../storage_service/storage_services.dart';

class APIService {
  StorageServices storageServices = StorageServices();

  static Future<dynamic> signup({
    required String api,
    Map<String, dynamic>? body,
  }) async {
    try {
      var header = {"Content-Type": "application/json"};
      log("*** Request ***");
      log("URI : $api");

      final response = await http.post(
        headers: header,
        Uri.parse(api),
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        log("*** response ***");
        log("URI : $api");
        log("BODY : ${response.body}");

        return response.body;
      }
      log("status code ${response.statusCode} || API : $api");
      log("BODY : ${response.body}");
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  static Future<dynamic> login({
    required String api,
    Map<String, dynamic>? body,
  }) async {
    try {
      var header = {"Content-Type": "application/json"};
      log("*** Request ***");
      log("URI : $api");

      final response = await http.post(
        headers: header,
        Uri.parse(api),
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        log("*** response ***");
        log("URI : $api");
        log("BODY : ${response.body}");

        return response.body;
      }
      log("status code ${response.statusCode} || API : $api");
      log("BODY : ${response.body}");
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  static Future<dynamic> get({required String api}) async {
    try {
      final token = await StorageServices().read(tokenKey);
      Map<String, String> header = {"Content-Type": "application/json"};
      if (token != null) {
        header["Authorization"] = "Bearer $token";
      }

      log("*** Request ***");
      log("URI : $api");

      final response = await http.get(Uri.parse(api), headers: header);

      if (response.statusCode == 200) {
        log("*** response ***");
        log("URI : $api");

        log("BODY : ${response.body}");

        return response.body;
      }
      log("=======================");
      log("BODY : ${response.body}");
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<dynamic> post({
    required String api,
    String? id,
    Map<String, dynamic>? body,
  }) async {
    try {
      final token = await StorageServices().read(tokenKey);
      Map<String, String> header = {"Content-Type": "application/json"};
      if (token != null) {
        header["Authorization"] = "Bearer $token";
      }

      log("*** Request ***");
      log("URI : $api");
      log("$body");

      final response = await http.post(
        headers: header,
        Uri.parse(api),
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        log("*** response ***");
        log("URI : $api");

        log("${response.body}");

        return response.body;
      }
      log(
        "status code ${response.statusCode} || API : $api :: Response ${response.body}",
      );
      log("=======================");
      log("BODY : ${response.body}");
    } catch (e) {
      log("error : *** $e *** ");
    }
  }
}
