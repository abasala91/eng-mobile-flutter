import 'dart:convert';

import 'package:eng/models/http_exception.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../variables.dart';

class ReserveItem {
  final String id;
  final String serviceId;
  final String title;
  final String name;
  final String persons;
  final String adults;
  final String teens;
  final String chairs;
  final String imgUrl;
  final String reserveStatus;
  final bool isTosDone;
  final bool isBenefit;

  ReserveItem(
      {@required this.id,
      @required this.serviceId,
      @required this.persons,
      @required this.adults,
      @required this.teens,
      @required this.chairs,
      @required this.name,
      @required this.title,
      @required this.imgUrl,
      @required this.reserveStatus,
      @required this.isTosDone,
      @required this.isBenefit});
}

class Reserve with ChangeNotifier {
  final String authToken;
  final String userId;
  List<ReserveItem> _items;

  Reserve(this.authToken, this._items, this.userId);

  List<ReserveItem> get items {
    return [..._items];
  }

  int totaApplicants = 0;

  Future<String> addItem(String serviceId, String persons, String adults,
      String teens, String chairs) async {
    try {
      var url = Uri.parse('$appUrl/api/reserves');
      final response = await http.post(url, body: {
        "tripId": serviceId,
        "persons": persons,
        "adults": adults,
        "teens": teens,
        "chairs": chairs,
        "reserveStatus": 'pending'
      }, headers: {
        "x-auth-token": authToken
      });

      if (response.statusCode >= 400) {
        throw HttpException(response.body);
      }
      if (jsonDecode(response.body)["status"] == 200) {
        return jsonDecode(response.body)["message"];
      }

      url = Uri.parse('$appUrl/api/reserves');
      final getResponse =
          await http.get(url, headers: {"x-auth-token": authToken});
    } catch (e) {
      throw e;
    }
    notifyListeners();
  }

  Future<void> getItems() async {
    final url = Uri.parse('$appUrl/api/reserves/me');
    final response = await http.get(url, headers: {"x-auth-token": authToken});
    final extractedData = jsonDecode(response.body) as List;
    if (extractedData == null) {
      return;
    }
    List<ReserveItem> loadedData = [];
    for (var i = 0; i < extractedData.length; i++) {
      final result = ReserveItem(
          id: extractedData[i]['_id'],
          serviceId: extractedData[i]['tripId']['_id'],
          name: extractedData[i]['userId']['name'],
          persons: extractedData[i]['persons'].toString(),
          title: extractedData[i]['tripId']['title'],
          isTosDone: extractedData[i]['tripId']['isTosDone'],
          isBenefit: extractedData[i]['isBenefit'],
          imgUrl: extractedData[i]['tripId']['imgUrl'] != ''
              ? extractedData[i]['tripId']['imgUrl']
                  .toString()
                  .replaceAll('\\', '/')
              : null,
          reserveStatus: extractedData[i]['reserveStatus']);

      loadedData.add(result);
    }
    _items = loadedData;
    notifyListeners();
  }

  List<ReserveItem> getTosServices() {
    return items.where((element) {
      return element.isTosDone || element.isBenefit;
    }).toList();
  }

  List<ReserveItem> getPendingServices() {
    return items
        .where((element) => element.isTosDone == false && !element.isBenefit)
        .toList();
  }

  Future<void> getAllReserves(String tripId) async {
    final url = Uri.parse('$appUrl/api/reserves/$tripId');
    try {
      final response =
          await http.get(url, headers: {"x-auth-token": authToken});
      if (response.statusCode >= 400) {
        throw HttpException("No Data Available!");
      }
      final data = jsonDecode(response.body);
      totaApplicants = data[1];
      List<ReserveItem> lastData = [];
      for (var i = 0; i < data[0].length; i++) {
        final result = ReserveItem(
            id: data[0][i]['_id'],
            name: data[0][i]['userId']['name'],
            persons: data[0][i]['persons'].toString(),
            title: data[0][i]['tripId']['title'],
            imgUrl: data[0][i]['tripId']['imgUrl'],
            reserveStatus: data[0][i]['reserveStatus']);

        lastData.add(result);
      }
      _items = lastData;
      print(_items[0].persons);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> deleteItem(String id) async {
    try {
      final itemIndex = _items.indexWhere((element) => element.id == id);
      final deletedItem = _items.firstWhere((element) => element.id == id);
      _items.removeAt(itemIndex);
      final url = Uri.parse('$appUrl/api/reserves/me/$id');
      final response =
          await http.delete(url, headers: {"x-auth-token": authToken});
      if (response.statusCode >= 400) {
        print(response.body);
        throw HttpException(response.body);
      }
      ;
    } catch (e) {
      throw e;
    }

    notifyListeners();
  }
}
