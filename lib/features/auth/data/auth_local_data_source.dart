import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

class AuthLocalDataSource {
  final SharedPreferences sf;

  AuthLocalDataSource(this.sf);
  Future<void> saveToken(String token) async {
    await sf.setString(AuthDataConstants.token, token);
  }

  Future<String?> getToken() async {
    return sf.getString(AuthDataConstants.token);
  }

  Future<void> clearRole() async {
    await sf.remove(AuthDataConstants.token);
  }
}
