import 'package:clinicease/models/user_model.dart';
import 'package:clinicease/models/service_model.dart';
import 'package:clinicease/models/reward_model.dart';
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

  // Service Data
  static Future<void> setServiceData(ServiceModel service) async => await box.write('serviceData', service.toJson());
  static ServiceModel? getServiceData() {
    final serviceData = box.read('serviceData');
    if (serviceData != null) {
      return ServiceModel.fromJson(serviceData);
    }
    return null;
  }
  static Future<void> removeServiceData() async => await box.remove('serviceData');

  // Reward Data
  static Future<void> setRewardData(RewardModel reward) async => await box.write('rewardData', reward.toJson());
  static RewardModel? getRewardData() {
    final rewardData = box.read('rewardData');
    if (rewardData != null) {
      return RewardModel.fromJson(rewardData);
    }
    return null;
  }
  static Future<void> removeRewardData() async => await box.remove('rewardData');

  // Logout
  static Future<void> clearAll() async => await box.erase();
}