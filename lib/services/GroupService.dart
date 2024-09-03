import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> addGroup(String groupName, String groupType) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userId = prefs.getString('userId');

  if (userId == null) {
    print('Error: userId is null');
    return;
  }

  final url = Uri.parse('http://192.168.31.56:3000/addGroup');

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: json.encode({
      'userId': userId,
      'groupName': groupName,
      'groupType': groupType,
    }),
  );

  if (response.statusCode == 201) {
    print('Group added successfully');
  } else {
    print('Failed to add group: ${response.body}');
  }
}
