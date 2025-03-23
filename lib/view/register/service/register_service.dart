import 'dart:convert';
import 'dart:io';
import 'package:home_ease/constants/ursls.dart';
import 'package:home_ease/view/register/model/register_model.dart';
import 'package:http/http.dart' as http;

Future<UserRegistrationModel>userRegistrationService({
  required String name,
  required String email,
  required String password,
  required String phone,
  required String address,
  
 
}) async {
  try {
    Map<String, dynamic> param = {
      "username": name,
      "email": email,
      "password": password,
      "phone":phone,
       "address":address,
      
    };

    final response = await http.post(
      Uri.parse(UserUrl.user_register),
      body: jsonEncode(param),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
      },
    );
  final dynamic decoded = jsonDecode(response.body);
    if (response.statusCode == 200) {
    
      final response = UserRegistrationModel.fromJson(decoded);

      return response;
    } else {
      final Map<String, dynamic> errorResponse = jsonDecode(response.body);
      throw Exception(
        'Failed to register: ${errorResponse['message'] ?? 'Unknown error'}',
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
