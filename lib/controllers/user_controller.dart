import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserController extends GetxController {
  final RxList users = [].obs;
  final Box uploadedImagesBox = Hive.box('uploaded_images');

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    const url = 'https://reqres.in/api/users?page=2';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      users.value = data['data'];
    }
  }

  void saveImage(String userId, String imagePath) {
    uploadedImagesBox.put(userId, imagePath);
  }

  String? getImage(String userId) {
    return uploadedImagesBox.get(userId);
  }
}
