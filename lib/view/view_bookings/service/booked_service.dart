import 'dart:convert';
import 'dart:io';

import 'package:home_ease/constants/ursls.dart';
//import 'package:home_ease/utils/preference_value.dart';
import 'package:home_ease/view/view_bookings/model/booked_model.dart';
import 'package:http/http.dart' as http;

Future<List<BookedServiceModel>> bookedlistService(
  
) async {
  try {
     //String userId = await PreferenceValues.getUserId();
    Map<String, dynamic> params = {
      //'user_id':userId.toString(),
      'user_id':7.toString(),
    };
    final resp = await http.get(
      Uri.parse(UserUrl.view_bookings)
          .replace(queryParameters: params),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
      },
    );
    final List<dynamic> decoded = jsonDecode(resp.body);
    if (resp.statusCode == 200) {
      final response =
          decoded.map((item) => BookedServiceModel.fromJson(item)).toList();
      return response;
    } else {
      throw Exception('Failed to load response');
    }
  } on SocketException {
    throw Exception('Server error');
  } on HttpException {
    throw Exception('Something went wrong');
  } on FormatException {
    throw Exception('Bad request');
  } catch (e) {
    throw Exception(e.toString());
  }
}
