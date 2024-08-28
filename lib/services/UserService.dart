import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> sendData(
    String email, String password, String name, String phoneNumber) async {
  final url = Uri.parse('http://192.168.31.56:3000/addUser');

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

  if (response.statusCode == 201) {
    print('User added successfully');
  } else {
    print('Failed to add user: ${response.body}');
  }
}
