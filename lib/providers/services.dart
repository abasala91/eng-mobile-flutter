import 'dart:convert';
import 'dart:math';

import '../models/http_exception.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './service.dart';
import '../variables.dart';

class Services with ChangeNotifier {
  final String authToken;
  final String userId;
  Services(this.authToken, this._items, this.userId);
  List<Service> _items = [];

  List<Service> get items {
    return [..._items];
  }

  Service findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> fetchAndGet() async {
    var url = Uri.parse('$appUrl/api/trips');
    try {
      final extractedData =
          await http.get(url, headers: {"x-auth-token": authToken});
      if (extractedData == null) {
        return;
      }

      final data = jsonDecode(extractedData.body) as List;
      final List<Service> loadedData = [];
      if (data.length > 0) {
        for (var i = 0; i < data.length; i++) {
          final result = Service(
              description: data[i]["description"],
              id: data[i]["_id"],
              imgUrl: data[i]["imgUrl"].toString().replaceAll('\\', '/'),
              isReserve: data[i]["isReserve"],
              title: data[i]["title"],
              timeStamp: DateTime.parse(data[i]['timeStamp']),
              validDays: data[i]["validDays"] != null
                  ? DateTime.parse(data[i]["validDays"])
                  : null,
              maxPersons: data[i]['maxPersons'],
              serviceType: data[i]['serviceType'],
              socialDays: data[i]['socialDays'],
              attendance: data[i]["requiredAttendance"],
              applicants: data[i]["socialApplicants"]);

          loadedData.add(result);
        }
      }

      _items = loadedData;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> addNewService(Service service) async {
    final url = '$appUrl/api/trips';

    try {
      final response = await http.post(Uri.parse(url), body: {
        "title": service.title,
        "imgUrl": service.imgUrl,
        "description": service.description,
      }, headers: {
        "x-auth-token": authToken
      });
      final extractedData = jsonDecode(response.body);
      final newService = Service(
          description: service.description,
          id: extractedData["_id"],
          imgUrl: service.imgUrl,
          title: service.title,
          timeStamp: DateTime.parse(extractedData['timeStamp']));
      _items.add(newService);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateService(String id, Service newService) async {
    final serviceIndex = _items.indexWhere((element) => element.id == id);
    if (serviceIndex >= 0) {
      final url = Uri.parse('$appUrl/api/trips/$id');
      final response = await http.put(url, body: {
        "title": newService.title,
        "description": newService.description,
        "imgUrl": newService.imgUrl
      }, headers: {
        "x-auth-token": authToken
      });

      _items[serviceIndex] = newService;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteItem(String id) async {
    final url = Uri.parse('$appUrl/api/trips/$id');
    var existingItem = _items.firstWhere((element) => element.id == id);
    final index = _items.indexWhere((element) => element.id == id);
    _items.removeAt(index);
    notifyListeners();
    final response =
        await http.delete(url, headers: {"x-auth-token": authToken});
    if (response.statusCode >= 400) {
      _items.insert(index, existingItem);
      notifyListeners();
      throw HttpException("Cannot delete this item.");
    }
    existingItem = null;
  }
}
