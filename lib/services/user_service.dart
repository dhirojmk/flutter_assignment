import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class UserService {
  static Future<List<UserModel>> fetchUsers() async {
    final url = Uri.parse('https://reqres.in/api/users?page=2');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List users = jsonResponse['data'];
      return users.map((user) => UserModel.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }
}
