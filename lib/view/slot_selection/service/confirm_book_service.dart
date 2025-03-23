import 'dart:convert';
import 'dart:io';
import 'package:home_ease/constants/ursls.dart';
import 'package:home_ease/view/slot_selection/model/confirm_book_model.dart';
import 'package:http/http.dart' as http;

Future<ConfirmBookMoldel> confirmCheckoutScreenService({
  required String slot_id,
  required String provider_id,
  required String date,
 
}) async {
  try {
   
    Map<String, dynamic> param = {
      "user_id": 7.toString(),
      "slot_id": slot_id, 
      "date": date, 
      "provider_id": provider_id, 
      
    
    };

    final resp = await http.post(
      Uri.parse(UserUrl.confirm_book),
      body: jsonEncode(param),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    if (resp.statusCode == 201) {
      final dynamic decoded = jsonDecode(resp.body);
      final response = ConfirmBookMoldel.fromJson(decoded);
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
