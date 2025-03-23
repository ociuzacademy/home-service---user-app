import 'dart:convert';
import 'dart:io';
import 'package:home_ease/constants/ursls.dart';
import 'package:home_ease/view/payment/model/card_model.dart';
import 'package:http/http.dart' as http;

Future<CardPaymentModel> cardPayService({
  required String name,
  required String booking_id,
  required String card_number,
  required String expiry_date,
  required String cvv,
}) async {
  try {
    //String userId = await PreferenceValues.getUserId();
    Map<String, dynamic> param = {
      "booking_id": booking_id,
      "card_holder_name": name,
      "card_number": card_number,
      "expiry_date": expiry_date,
      "cvv": cvv,
    };

    final resp = await http.post(
      Uri.parse(UserUrl.cardpayment),
      body: jsonEncode(param),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    if (resp.statusCode == 201) {
      final dynamic decoded = jsonDecode(resp.body);
      final response = CardPaymentModel.fromJson(decoded);

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
