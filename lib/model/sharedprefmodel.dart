import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;

class SharedPrefsModel {

  static Future init() async {
    prefs = await SharedPreferences.getInstance();
  }

  late String authKey, userId, email;

  String getAuthKey() {
    authKey = prefs.getString('auth_key')!;
    return authKey;
  }

  void setAuthKey(String authKey) {
    init();
    this.authKey = authKey;
  }

  String getUserId() {
    init();
    userId = prefs.getString('user_id')!;
    return userId;
  }

  void setUserId(String userId) {
    init();
    this.userId = userId;
  }

  String getEmail() {
    init();
    email = prefs.getString('email')!;
    return email;
  }

  void setEmail(String email) {
    init();
    prefs.setString('email', email);
    this.email = email;
  }

  saveSharedPrefs() async {
    await SharedPrefsModel.init();

    getEmail();
    getAuthKey();
    getUserId();
  }
}