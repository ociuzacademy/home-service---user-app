import 'dart:convert';
import 'dart:io';

import 'package:home_ease/constants/ursls.dart';
import 'package:home_ease/view/view_bookings/model/completed_model.dart';
import 'package:http/http.dart' as http;

Future<CompletedServiceModel> completedService({
  required String booking_id,
}) async {
  try {
    Map<String, dynamic> param = {
      "booking_id": booking_id,
    };

    final resp = await http.patch(
      Uri.parse(UserUrl.status_completed),
      body: jsonEncode(param),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    if (resp.statusCode == 200) {
      final dynamic decoded = jsonDecode(resp.body);
      final response = CompletedServiceModel.fromJson(decoded);

      return response;
    } else {
      final Map<String, dynamic> errorResponse = jsonDecode(resp.body);
      throw Exception(
        '${errorResponse['message'] ?? 'Unknown error'}',
      );
    }
  } on SocketException {
    throw Exception('No Internet connection');
  } on HttpException {
    throw Exception('Server error');
  } on FormatException {
    throw Exception('Bad response format');
  } catch (e) {
    throw Exception('Unexpected error: ${e.toString()}');
  }
}
