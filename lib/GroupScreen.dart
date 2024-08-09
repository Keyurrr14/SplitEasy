import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  TextEditingController _amountController = TextEditingController();
  // ignore: unused_field
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    groupContacts = widget.group.contacts;
    _addDefaultYouContact();
    _futureContacts = _fetchContacts();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  void _addDefaultYouContact() {
    Contact youContact = Contact(
      displayName: 'You',
      givenName: 'You',
    );
    if (!groupContacts.any((contact) => contact.displayName == 'You')) {
      groupContacts.add(youContact);
    }
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

  void _showSplitDetails(BuildContext context) {
    if (selectedContacts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select contacts to split the amount.'),
        ),
      );
      return;
    }

    final amount = double.tryParse(_amountController.text) ?? 0;
    final splitAmount = amount / selectedContacts.length;

    // Debug: Print calculated values
    print("Total amount: $amount");
    print("Number of selected contacts: ${selectedContacts.length}");
    print("Split amount: $splitAmount");

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Split Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: selectedContacts.map((contact) {
              return ListTile(
                title: Text(contact.displayName ?? 'No Name'),
                trailing: Text('₹ ${splitAmount.toStringAsFixed(2)}'),
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 10, left: 20),
              child: Text(
                'Members',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
            SingleChildScrollView(
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
                        if (contact.displayName != 'You')
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
            Padding(
              padding: const EdgeInsets.only(left: 30, top: 40),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Description'),
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Enter description',
                            hintStyle: TextStyle(color: Color(0xffAEBDC2)),
                            border: InputBorder.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Amount'),
                        TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: const InputDecoration(
                            hintText: '₹ 0',
                            hintStyle: TextStyle(color: Color(0xffAEBDC2)),
                            border: InputBorder.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20, left: 20),
              child: Row(
                children: [
                  Text(
                    'Split Among',
                    style: TextStyle(fontSize: 15),
                  ),
                  Text(
                    '  (Tap the names below)',
                    style: TextStyle(fontSize: 10),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount:
                      groupContacts.length + 1, // +1 for the 'Equally' button
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(left: 10, top: 8, bottom: 8),
                        child: OutlinedButton(
                          onPressed: () {
                            // Define the action for 'Equally' button here
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                                color: Color(0xff1f2128), width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.only(
                              top: 5,
                              bottom: 5,
                              left: 10,
                              right: 10,
                            ),
                          ),
                          child: const Text(
                            'Equally',
                            style: TextStyle(
                              color: Color(0xff1f2128),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    } else {
                      Contact contact = groupContacts[index - 1];
                      return Padding(
                        padding:
                            const EdgeInsets.only(left: 10, top: 8, bottom: 8),
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              if (selectedContacts.contains(contact)) {
                                selectedContacts.remove(contact);
                              } else {
                                selectedContacts.add(contact);
                              }
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                                color: Color(0xff1f2128), width: 2),
                            backgroundColor: selectedContacts.contains(contact)
                                ? const Color(
                                    0xff1f2128) // Black background when selected
                                : Colors
                                    .transparent, // Default transparent background
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.only(
                              top: 5,
                              bottom: 5,
                              left: 10,
                              right: 10,
                            ),
                          ),
                          child: Text(
                            contact.displayName ?? 'No Name',
                            style: TextStyle(
                              color: selectedContacts.contains(contact)
                                  ? Colors.white // White text when selected
                                  : const Color(
                                      0xff1f2128), // Black text when not selected
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      // Define action for contact button here
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: const Color(0xffdff169),
                      side:
                          const BorderSide(color: Color(0xff1f2128), width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.only(
                        top: 5,
                        bottom: 5,
                        left: 10,
                        right: 10,
                      ),
                    ),
                    child: const Text(
                      'Add more item',
                      style: TextStyle(
                        color: Color(0xff1f2128),
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: OutlinedButton(
                      onPressed: () => {
                        // Define action for contact button here
                        _showSplitDetails(context)
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xffdff169),
                        side: const BorderSide(
                            color: Color(0xff1f2128), width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.only(
                          top: 5,
                          bottom: 5,
                          left: 10,
                          right: 10,
                        ),
                      ),
                      child: const Text(
                        'Done',
                        style: TextStyle(
                          color: Color(0xff1f2128),
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addContacts,
        elevation: 5,
        backgroundColor: const Color(0xff1f2128),
        label: const Text(
          'Add Members',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        icon: const Icon(
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
        String _searchQuery = '';
        return FutureBuilder<List<Contact>>(
          future: _futureContacts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                title: const Text(
                  'Add Members',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
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
                    titlePadding: const EdgeInsets.only(top: 25, left: 25),
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
                            decoration: const InputDecoration(
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
                            padding: const EdgeInsets.only(bottom: 10),
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
