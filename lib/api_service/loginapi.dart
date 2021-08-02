import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class APIService {
  Future<Map<String, dynamic>> login(String username, String password, BuildContext context) async {

    String url = "http://www.internsorbit.com:8080/nagarparishad/clueemplogin/$username/$password";

    Map<String, dynamic> responseData;

    final response = await http.post(Uri.parse(url),
        // headers: {
        //   'Authorization': 'Basic Z3Jvd3d1MjAyMDpLcS5rLVZhK2gkNzNufiku'},
        // body:  {
        //   'username': username,
        //   'password': password
        // }
    );

    if (response.statusCode == 200) {
      responseData = json.decode(response.body);
      if (responseData['status'] != 200) {
        _displaySnackBar(context);
      }
    } else {
      _displaySnackBar(context);
      throw Exception('Failed to load data!');
    }

    return responseData;
  }

  _displaySnackBar(BuildContext context) {
    const snackBar = SnackBar(content: Text('Invalid credentials'));
    Scaffold.of(context).showSnackBar(snackBar);
  }
}