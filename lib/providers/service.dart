import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Service with ChangeNotifier {
  final String id;
  final String title;
  final String imgUrl;
  final String description;
  final DateTime timeStamp;
  final bool isReserve;
  final DateTime validDays;
  final int maxPersons;
  final String serviceType;
  final int attendance;
  final int applicants;
  final List socialDays;

  Service(
      {@required this.description,
      @required this.id,
      @required this.imgUrl,
      @required this.title,
      @required this.timeStamp,
      @required this.isReserve,
      @required this.validDays,
      @required this.maxPersons,
      @required this.serviceType,
      @required this.attendance,
      @required this.applicants,
      @required this.socialDays});
}
