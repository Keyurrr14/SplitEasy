import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> sendGroupData(
    String groupName, String groupType) async {
  final url = Uri.parse('http://192.168.31.56:3000/api/group/add');

  // Retrieve the userId from SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userId = prefs.getString('userId');

  if (userId == null) {
    print('Error: userId is null');
    return;
  }

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: json.encode({
      'userId': userId,
      'groupName': groupName,
      'groupType': groupType,
    }),
  );

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode == 201) {
    final data = json.decode(response.body);
    print('Decoded data: $data');
    final groupId = data['_id'];

    if (groupId != null) {
      // Save groupId in SharedPreferences
      await prefs.setString('groupId', groupId);

      print('Group added successfully with ID: $groupId');
    } else {
      print('Error: groupId is null');
    }
  } else {
    print('Failed to add group: ${response.body}');
  }
}