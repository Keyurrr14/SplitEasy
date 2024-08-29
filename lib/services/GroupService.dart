import 'dart:convert';

import 'package:http/http.dart' as http;

Future<void> addGroup(String userId, String groupName, String groupType) async {
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
