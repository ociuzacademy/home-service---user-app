import 'dart:convert';
import 'dart:io';
import 'package:home_ease/constants/ursls.dart';
import 'package:home_ease/utils/preference_value.dart';
import 'package:home_ease/view/feedback/model/feedback_model.dart';
import 'package:http/http.dart' as http;

Future<FeedbackModel> userFeedbackService({
  required String rating,
  required String feedback,
  required String booking_id,
}) async {
  try {

     String userId = await PreferenceValues.getUserId();
    Map<String, dynamic> param = {
      "user_id": userId,
      "rating": rating,
      "review_text" :feedback,
      "booking_id" :booking_id,
    };

    final resp = await http.post(
      Uri.parse(UserUrl.feedback), 
      body: jsonEncode(param),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    if (resp.statusCode == 201) {
      /**
       *  final List<dynamic> decoded = jsonDecode(resp.body);
      final response =
          decoded.map((item) => ProductModel.fromJson(item)).toList();
      return response;
       */

      final dynamic decoded = jsonDecode(resp.body);
      final response = FeedbackModel.fromJson(decoded);
          
      return response;
    } else {
      final Map<String, dynamic> errorResponse = jsonDecode(resp.body);
      throw Exception(
        'Failed to login: ${errorResponse['message'] ?? 'Unknown error'}',
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