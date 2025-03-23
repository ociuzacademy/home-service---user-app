import 'dart:convert';
import 'dart:io';
import 'package:home_ease/constants/ursls.dart';
import 'package:home_ease/view/slot_selection/model/available_slot_model.dart';
import 'package:http/http.dart' as http;

Future<AvailableSlotMoldel> confirmSlotService(
  {
    required String date,
    required String provider_id,
  }
  
) async {
  try {
     Map<String, dynamic> params = {
      'date': date,
      'provider_id' :provider_id,
     };

    final resp = await http.get(
      Uri.parse(UserUrl.available_slot).replace(queryParameters: params),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
      },
    );
    if (resp.statusCode == 200) {

      final dynamic decoded = jsonDecode(resp.body);
      final response = AvailableSlotMoldel.fromJson(decoded);
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