import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:spliteasy/GroupModel.dart';

class GroupScreen extends StatefulWidget {
  final Group group;

  const GroupScreen({Key? key, required this.group}) : super(key: key);

  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  late List<Contact> groupContacts;
  late Future<List<Contact>> _futureContacts;
  List<Contact> selectedContacts = [];
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    groupContacts = widget.group.contacts;
    _futureContacts = _fetchContacts();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  Future<List<Contact>> _fetchContacts() async {
    if (await Permission.contacts.request().isGranted) {
      final Iterable<Contact> contacts = await ContactsService.getContacts();
      return contacts.toList();
    } else {
      return [];
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.group.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: groupContacts.map((contact) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: const Color(0xffdff169),
                        child: Text(
                          _getInitials(contact.displayName),
                          style: const TextStyle(
                              fontSize: 20, color: Color(0xff1f2128)),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        width: 60,
                        child: Text(
                          contact.displayName ?? 'No Name',
                          style: const TextStyle(fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: -5,
                    right: -5,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          groupContacts.remove(contact);
                        });
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addContacts,
        elevation: 5,
        backgroundColor: Color(0xff1f2128),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<void> _addContacts() async {
    showDialog(
      context: context,
      builder: (context) {
        String _searchQuery = ''; // Move _searchQuery inside the dialog
        return FutureBuilder<List<Contact>>(
          future: _futureContacts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return AlertDialog(
                title: const Text('Add Members'),
                content: const SizedBox(
                  width: double.maxFinite,
                  height: 300,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Color(0xff1f2128),
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return AlertDialog(
                title: const Text('Error'),
                content: const Text('Failed to load contacts'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            } else {
              Iterable<Contact> allContacts = snapshot.data!;
              return StatefulBuilder(
                builder: (context, setState) {
                  Iterable<Contact> filteredContacts =
                      allContacts.where((contact) {
                    return contact.displayName
                            ?.toLowerCase()
                            .contains(_searchQuery.toLowerCase()) ??
                        false;
                  });
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    titlePadding: EdgeInsets.only(top: 25, left: 25),
                    title: const Text(
                      'Add Members',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    contentPadding: EdgeInsets.zero,
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 250,
                          height: 50,
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search',
                              hintStyle: TextStyle(fontSize: 15),
                              prefixIcon: Icon(
                                Icons.search,
                                size: 20,
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: double.maxFinite,
                          height: 200,
                          child: ListView.builder(
                            padding: EdgeInsets.only(bottom: 10),
                            itemCount: filteredContacts.length,
                            itemBuilder: (context, index) {
                              Contact contact =
                                  filteredContacts.elementAt(index);
                              bool isSelected =
                                  selectedContacts.contains(contact);
                              return ListTile(
                                title: Text(
                                  contact.displayName ?? 'No Name',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                trailing: isSelected
                                    ? const Icon(Icons.check,
                                        color: Colors.green)
                                    : null,
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      selectedContacts.remove(contact);
                                    } else {
                                      selectedContacts.add(contact);
                                    }
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _addSelectedContacts();
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xff1f2128),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Add'),
                      ),
                    ],
                  );
                },
              );
            }
          },
        );
      },
    );
  }

  void _addSelectedContacts() {
    setState(() {
      groupContacts.addAll(
        selectedContacts.where((contact) => !groupContacts.contains(contact)),
      );
      selectedContacts.clear();
    });
  }

  String _getInitials(String? displayName) {
    if (displayName == null || displayName.isEmpty) return "";
    List<String> nameParts = displayName.split(" ");
    String initials = nameParts.length > 1
        ? nameParts[0][0] + nameParts[1][0]
        : nameParts[0][0];
    return initials.toUpperCase();
  }
}
