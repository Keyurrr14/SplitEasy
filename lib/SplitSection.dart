import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplitSection extends StatefulWidget {
  final TextEditingController amountController;
  final List<Contact> groupContacts;
  final List<Contact> selectedContacts;
  final VoidCallback onDonePressed;
  final VoidCallback onDeletePressed; // Callback to handle deletion
  final Function(Contact)
      onContactSelected; // Callback to handle contact selection

  const SplitSection({
    Key? key,
    required this.amountController,
    required this.groupContacts,
    required this.selectedContacts,
    required this.onDonePressed,
    required this.onDeletePressed, // Initialize callback for deletion
    required this.onContactSelected, // Initialize callback for contact selection
  }) : super(key: key);

  @override
  _SplitSectionState createState() => _SplitSectionState();
}

class _SplitSectionState extends State<SplitSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                      controller: widget.amountController,
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
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.groupContacts.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 10, top: 8, bottom: 8),
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
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                      ),
                      child: const Text(
                        'Equally',
                        style:
                            TextStyle(color: Color(0xff1f2128), fontSize: 16),
                      ),
                    ),
                  );
                } else {
                  Contact contact = widget.groupContacts[index - 1];
                  bool isSelected = widget.selectedContacts.contains(contact);
                  return Padding(
                    padding: const EdgeInsets.only(left: 10, top: 8, bottom: 8),
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          widget.onContactSelected(contact);
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            color: Color(0xff1f2128), width: 2),
                        backgroundColor: isSelected
                            ? const Color(0xff1f2128)
                            : Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                      ),
                      child: Text(
                        contact.displayName ?? 'No Name',
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : const Color(0xff1f2128),
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
                  // Define action for 'Add more item' button here
                },
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
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: OutlinedButton(
                      onPressed: widget.onDeletePressed,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        side: const BorderSide(
                            color: Color(0xff1f2128), width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                      ),
                      child: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.only(right: 18.0),
                    child: OutlinedButton(
                      onPressed: widget.onDonePressed,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xffdff169),
                        side: const BorderSide(
                            color: Color(0xff1f2128), width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                      ),
                      child: const Text(
                        'Done',
                        style:
                            TextStyle(color: Color(0xff1f2128), fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
