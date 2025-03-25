// import 'package:home_ease/utils/preference_keys.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class PreferenceValues {
//   static Future<void> disableIntroScreen() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     await preferences.setBool(PreferenceKeys.isFirstLaunch, false);
//   }

//   static Future<void> userLogin({
//     required String userId,
//   }) async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     await preferences.setBool(PreferenceKeys.isLoggedIn, true);
//     await preferences.setString(PreferenceKeys.userId, userId);
//   }

//   static Future<void> userLogout() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     await preferences.setBool(PreferenceKeys.isLoggedIn, false);
//     await preferences.remove(PreferenceKeys.userId);
//   }

//   static Future<bool> getIntroScreenStatus() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     bool? isFirstLaunch = preferences.getBool(PreferenceKeys.isFirstLaunch);
//     return isFirstLaunch ?? true;
//   }

//   static Future<bool> getLoginStatus() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     bool? isLoggedIn = preferences.getBool(PreferenceKeys.isLoggedIn);
//     return isLoggedIn ?? false;
//   }

//   static Future<String> getUserId() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     String? serviceCentreId = preferences.getString(PreferenceKeys.userId);
//     return serviceCentreId ?? "0";
//   }
// }
