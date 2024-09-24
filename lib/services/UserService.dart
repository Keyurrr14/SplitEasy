import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> sendData(
    String email, String password, String name, String phoneNumber) async {
  final url = Uri.parse('http://192.168.31.56:3000/api/user/add');

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: json.encode({
      'email': email,
      'password': password,
      'name': name,
      'phoneNumber': phoneNumber,
    }),
  );

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode == 201) {
    final data = json.decode(response.body);
    print('Decoded data: $data');
    final userId = data['userId'];

    if (userId != null) {
      // Save userId in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', userId);

      print('User added successfully with ID: $userId');
    } else {
      print('Error: userId is null');
    }
  } else {
    print('Failed to add user: ${response.body}');
  }
}
