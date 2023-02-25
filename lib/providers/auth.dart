import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './user.dart';
import '../variables.dart';

class Auth with ChangeNotifier {
  String _token;
  String _userId;

  String get userId {
    return _userId;
  }

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_token != null) {
      return _token;
    }
    return null;
  }

  Future<void> signin(String engId, String password) async {
    var url = Uri.parse('$appUrl/api/auth');

    final response = await http.post(
      url,
      body: {
        'engId': engId,
        'password': password,
      },
    );

    if (response.statusCode >= 400) {
      throw HttpException(response.body);
    }
    _userId = jsonDecode(response.body)["userId"];
    _token = jsonDecode(response.body)["token"];
    url = Uri.parse("$appUrl/api/users/me");
    final result = await http.get(url, headers: {"x-auth-token": _token});
    final extractedData = jsonDecode(result.body);
    userData = User(
        name: extractedData["name"],
        engId: extractedData["engId"],
        department: extractedData["department"],
        graduatedYear: extractedData['graduationYear'],
        address: extractedData['address'],
        emial: extractedData['email'],
        phoneNo: extractedData['phone'],
        imgUrl: extractedData['imgUrl'] != null
            ? extractedData['imgUrl'].toString().replaceAll('\\', '/')
            : null);

    final prefs = await SharedPreferences.getInstance();
    final userLoginData = jsonEncode({
      "token": _token,
      "userId": _userId,
    });
    prefs.setString('userLoginData',
        userLoginData); // we safe the data in device flash memory
    notifyListeners();
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userLoginData')) {
      return false;
    }
    final extractedData =
        jsonDecode(prefs.getString('userLoginData')) as Map<String, Object>;

    _token = extractedData['token'];
    _userId = extractedData['userId'];
    notifyListeners();
    return true;
  }

  User userData = User(
      name: "N/A",
      department: "N/A",
      engId: "N/A",
      graduatedYear: "N/A",
      phoneNo: "N/A",
      address: "N/A",
      emial: "N/A",
      imgUrl: null);

  Future<void> updateUser(
      String phone, String email, String address, imageFilePath) async {
    final url = Uri.parse("$appUrl/api/users/me");
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
        '$appUrl/api/users/upload/$userId',
      ),
    );
    request.fields['userId'] = userId;
    imageFilePath != null
        ? request.files.add(http.MultipartFile.fromBytes(
            'picture', File(imageFilePath.path).readAsBytesSync(),
            filename: 'image_${userId}.jpg'))
        : null;

    // var res = await request.send();
    final response = await Future.wait([
      http.put(url,
          body: {"phone": phone, "email": email, "address": address},
          headers: {"x-auth-token": _token}),
      request.send()
    ]);
    notifyListeners();
  }

  Future<void> getUser() async {
    final url = Uri.parse("$appUrl/api/users/me");
    final result = await http.get(url, headers: {"x-auth-token": _token});
    final extractedData = jsonDecode(result.body);
    userData = User(
        name: extractedData["name"],
        engId: extractedData["engId"],
        department: extractedData["department"],
        graduatedYear: extractedData['graduationYear'],
        address: extractedData['address'],
        emial: extractedData['email'],
        phoneNo: extractedData['phone'],
        isSubPaid: extractedData['isSubPaid'],
        imgUrl: extractedData['imgUrl'] != ""
            ? extractedData['imgUrl'].toString().replaceAll('\\', '/')
            : null);
    notifyListeners();
  }

  void logout() async {
    _token = null;
    _userId = null;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();

    notifyListeners();
  }

  Future<void> changePassword(String oldPass, String newPass) async {
    final url = Uri.parse("${appUrl}/api/users/change-password");
    final response = await http.post(url, headers: {
      "x-auth-token": _token
    }, body: {
      "oldPass": oldPass,
      "newPass": newPass,
    });

    if (response.statusCode >= 400) {
      throw HttpException(response.body);
    }
    logout();
    notifyListeners();
  }

  Future<void> postComplaint(String message) async {
    final url = Uri.parse("${appUrl}/api/users/post-complaint");
    final response = await http.post(url, headers: {
      "x-auth-token": _token
    }, body: {
      "message": message,
    });
    if (response.statusCode >= 400) {
      throw HttpException(response.body);
    }

    notifyListeners();
  }
}
