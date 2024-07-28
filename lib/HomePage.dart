import 'package:flutter/material.dart';
import 'package:spliteasy/Account%20Screens/Account.dart';

class HomePage extends StatefulWidget {
  final String fullName;
  final String phoneNumber;

  const HomePage(
      {super.key, required this.fullName, required this.phoneNumber});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Group> groups = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: IconButton(
            icon: const Icon(
              Icons.logout_rounded,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Account(
                        fullName: widget.fullName,
                        phoneNumber: widget.phoneNumber)));
              },
              icon: const Icon(
                Icons.account_circle_outlined,
                color: Colors.black,
                size: 30,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                  color: const Color(0xffdff169),
                  borderRadius: BorderRadius.circular(10)),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 15, left: 15),
                    child: Text(
                      'I\'m owed',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5, left: 15),
                    child: Text(
                      '0,00',
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.w900),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 130,
                    decoration: BoxDecoration(
                        color: const Color(0xffAEBDC2),
                        borderRadius: BorderRadius.circular(10)),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 15, left: 15),
                          child: Text(
                            'My costs',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5, left: 15),
                          child: Text(
                            '0,00',
                            style: TextStyle(
                                fontSize: 40, fontWeight: FontWeight.w900),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    height: 130,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: const Color(0xffAEBDC2), width: 2),
                        borderRadius: BorderRadius.circular(10)),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 15, left: 15),
                          child: Text(
                            'Total costs',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5, left: 15),
                          child: Text(
                            '0,00',
                            style: TextStyle(
                                fontSize: 40, fontWeight: FontWeight.w900),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Groups',
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            Column(
              children: groups
                  .map((group) => Container(
                        width: double.infinity,
                        height: 70,
                        margin: const EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xffE9E9E9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: ListTile(
                            leading: Icon(group.icon, color: Color(0xff1f2128)),
                            title: Text(
                              group.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff1f2128),
                              ),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 20,
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 3,
              backgroundColor: const Color(0xff1f2128),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              _showCreateGroupDialog(context);
            },
            child: const Text(
              'Add Costs',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  void _showCreateGroupDialog(BuildContext context) {
    TextEditingController groupNameController = TextEditingController();
    GroupType? selectedGroupType;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              title: const Text(
                'Create a Group',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Group Name',
                      style: TextStyle(fontSize: 12),
                    ),
                    TextField(
                      controller: groupNameController,
                      decoration: const InputDecoration(
                        hintText: 'Enter a group name',
                        hintStyle: TextStyle(fontSize: 14),
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Group Type',
                      style: TextStyle(fontSize: 12),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: GroupType.values.map((type) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedGroupType = type;
                              });
                            },
                            child: _buildGroupTypeCard(
                                type, selectedGroupType == type),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
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
                TextButton(
                  onPressed: () {
                    if (groupNameController.text.isNotEmpty &&
                        selectedGroupType != null) {
                      Navigator.of(context).pop({
                        'groupName': groupNameController.text,
                        'groupType': selectedGroupType,
                      });
                    }
                  },
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xff1f2128),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  child: const Text('Create'),
                ),
              ],
            );
          },
        );
      },
    ).then((value) => {
          if (value != null)
            {
              setState(() {
                groups.add(Group(
                    name: value['groupName'], icon: value['groupType']!.icon));
              })
            }
        });
  }

  Widget _buildGroupTypeCard(GroupType type, bool isSelected) {
    return Card(
      elevation: isSelected ? 4 : 2,
      color: isSelected ? Colors.blueAccent : const Color(0xffE9E9E9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(type.icon,
                size: 30, color: isSelected ? Colors.white : Colors.black),
            const SizedBox(height: 8),
            Text(type.name,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.black)),
          ],
        ),
      ),
    );
  }
}

class Group {
  final String name;
  final IconData icon;

  Group({required this.name, required this.icon});
}

enum GroupType {
  Home('Home', Icons.home_work_outlined),
  Trip('Trip', Icons.flight_rounded),
  Office('Office', Icons.business_rounded),
  Sports('Sports', Icons.sports_rounded),
  Others('Others', Icons.category_outlined);

  final String name;
  final IconData icon;

  const GroupType(this.name, this.icon);
}
