// group_model.dart
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

class Group {
  final String name;
  final IconData icon;
  List<Contact> contacts;

  Group({required this.name, required this.icon, required this.contacts});
}
