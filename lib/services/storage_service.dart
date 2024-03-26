import 'package:clinicease/models/user_model.dart';
import 'package:get_storage/get_storage.dart';

class StorageService {
  static GetStorage box = GetStorage();

  static Future<void> setUID(String uid) async => await box.write('uid', uid);
  static String? getUID() => box.read('uid')?.toString();
  static Future<void> removeUID() async => await box.remove('uid');

  // User Data
  static Future<void> setUserData(UserModel user) async => await box.write('userData', user.toJson());
  static UserModel? getUserData() {
    final userData = box.read('userData');
    if (userData != null) {
      return UserModel.fromJson(userData);
    }
    return null;
  }
  static Future<void> removeUserData() async => await box.remove('userData');


  // Logout
  static Future<void> clearAll() async => await box.erase();
}