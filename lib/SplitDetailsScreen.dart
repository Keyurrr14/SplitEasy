import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';

class SplitDetailsScreen extends StatelessWidget {
  final Map<Contact, double> splitDetails;

  const SplitDetailsScreen({Key? key, required this.splitDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Total Split Details'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: splitDetails.length,
        itemBuilder: (context, index) {
          final contact = splitDetails.keys.elementAt(index);
          final amount = splitDetails[contact]!;
          return ListTile(
            title: Text(contact.displayName ?? 'No Name'),
            trailing: Text('₹ ${amount.toStringAsFixed(2)}'),
          );
        },
      ),
    );
  }
}
