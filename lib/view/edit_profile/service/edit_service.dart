import 'dart:convert';
import 'dart:io';
import 'package:home_ease/constants/ursls.dart';
import 'package:home_ease/utils/preference_value.dart';
import 'package:home_ease/view/edit_profile/model/edit_profile_model.dart';

import 'package:http/http.dart' as http;

Future<EditProfileService> editProfileService({
  required String username,
  required String email,
  required String address,
  required String password,
  required String phone,
  
}) async {
     String userId = await PreferenceValues.getUserId();

  try {
    Map<String, dynamic> param = {
      'id':userId,
      "username": username,
      "email": email,
      "address": address,
      "password": password,
      "phone": phone,
      
    };

    final resp = await http.patch(
      Uri.parse(UserUrl.editprofile),
      body: jsonEncode(param),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    if (resp.statusCode == 200) {
      final dynamic decoded = jsonDecode(resp.body);
      final response = EditProfileService.fromJson(decoded);

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
