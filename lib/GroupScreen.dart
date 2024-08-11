import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:spliteasy/GroupModel.dart';
import 'package:spliteasy/SplitDetailsScreen.dart';
import 'package:spliteasy/SplitSection.dart';

class GroupScreen extends StatefulWidget {
  final Group group;

  const GroupScreen({Key? key, required this.group}) : super(key: key);

  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class SplitSectionData {
  final TextEditingController amountController;
  final List<Contact> selectedContacts;

  SplitSectionData({
    required this.amountController,
    required this.selectedContacts,
  });
}

class _GroupScreenState extends State<GroupScreen> {
  late List<Contact> groupContacts;
  late Future<List<Contact>> _futureContacts;
  List<Contact> selectedContacts = [];
  List<SplitSectionData> _splitSections = [];
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
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

    // Initialize with one SplitSection
    _splitSections.add(SplitSectionData(
      amountController: TextEditingController(),
      selectedContacts: [],
    ));
  }

  void _addDefaultYouContact() {
    bool hasYouContact =
        groupContacts.any((contact) => contact.displayName == 'You');

    if (!hasYouContact) {
      Contact youContact = Contact(
        displayName: 'You',
        givenName: 'You',
      );
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
    for (var section in _splitSections) {
      section.amountController.dispose();
    }
    super.dispose();
  }

  void _addMoreItem() {
    setState(() {
      _splitSections.add(SplitSectionData(
        amountController: TextEditingController(),
        selectedContacts: [],
      ));
    });
  }

  void _showSplitDetails(BuildContext context) {
  Map<Contact, double> totalSplit = {};

  for (var section in _splitSections) {
    final amount = double.tryParse(section.amountController.text) ?? 0;
    final splitAmount = amount / section.selectedContacts.length;

    for (var contact in section.selectedContacts) {
      if (totalSplit.containsKey(contact)) {
        totalSplit[contact] = totalSplit[contact]! + splitAmount;
      } else {
        totalSplit[contact] = splitAmount;
      }
    }
  }

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => SplitDetailsScreen(splitDetails: totalSplit),
    ),
  );
}


  void _handleContactSelected(Contact contact, SplitSectionData section) {
    setState(() {
      if (section.selectedContacts.contains(contact)) {
        section.selectedContacts.remove(contact);
      } else {
        section.selectedContacts.add(contact);
      }
    });
  }

  void _handleDeleteSection(SplitSectionData section) {
    setState(() {
      _splitSections.remove(section);
    });
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
            Column(
              children: _splitSections.map((section) {
                return SplitSection(
                  amountController: section.amountController,
                  groupContacts: groupContacts,
                  selectedContacts: section.selectedContacts,
                  onDonePressed: () => _showSplitDetails(context),
                  onContactSelected: (contact) =>
                      _handleContactSelected(contact, section),
                  onDeletePressed: () =>
                      _handleDeleteSection(section),
                );
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20),
              child: OutlinedButton(
                onPressed: _addMoreItem,
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xffdff169),
                  side: const BorderSide(color: Color(0xff1f2128), width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                ),
                child: const Text(
                  'Add more item',
                  style: TextStyle(color: Color(0xff1f2128), fontSize: 12),
                ),
              ),
            ),
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
