import 'package:get_storage/get_storage.dart';

class StorageService {
  GetStorage box = GetStorage();

  Future<void> setUID(String uid) async => await box.write('uid', uid);
  String? getUID() => box.read('uid')?.toString();
  Future<void> removeUID() async => await box.remove('uid');

}