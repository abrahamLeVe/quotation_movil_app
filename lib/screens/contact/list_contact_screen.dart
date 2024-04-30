import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pract_01/models/contact/get_all_contact.dart';
import 'package:pract_01/models/state/state_model.dart';
import 'package:pract_01/providers/contact_state.dart';
import 'package:pract_01/services/messaging/messaging_service.dart';
import 'package:pract_01/widgets/contact/contact_list_item.dart';
import 'package:provider/provider.dart' as provider;

class ContactListScreen extends StatefulWidget {
  final List<Contact> contactList;

  const ContactListScreen({
    Key? key,
    required this.contactList,
  }) : super(key: key);
  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  List<Contact> filtersContacts = [];
  bool isLoading = false;
  TextEditingController searchController = TextEditingController();
  final MessagingService _messagingService = MessagingService();
  StreamSubscription<void>? _subscription;
  late ContactState contactState;
  List<DataState> contactStates = [];
  DataState? selectedContactState;

  void filterContacts(List<Contact> contacts) {
    final String searchText = searchController.text.toUpperCase();
    if (searchText.isNotEmpty) {
      filtersContacts = contacts.where((contact) {
        final String code = contact.id.toString();
        return code.contains(searchText);
      }).toList();
    } else {
      filtersContacts = List.from(contacts);
    }
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();

    _subscription = _messagingService.onContactsUpdated.listen((_) {
      provider.Provider.of<ContactState>(context, listen: false)
          .loadNewContacts(context);
      setState(() {
        filtersContacts = contactState.contacts;
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      setState(() {
                        provider.Provider.of<ContactState>(context,
                            listen: false);
                        filtersContacts;
                      });
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter
                          .digitsOnly, // Permitir solo dígitos
                    ],
                    keyboardType:
                        TextInputType.number, // Mostrar teclado numérico
                    decoration: const InputDecoration(
                      labelText: 'Filtrar por código',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
            ],
          ),
          automaticallyImplyLeading: false,
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator()) // Mostrar spinner
            : provider.Consumer<ContactState>(
                builder: (context, contactState, _) {
                  final contacts = contactState.contacts;

                  filterContacts(contacts);

                  if (contactState.isNewNotificationAvailable()) {
                    filterContacts(contactState.contacts);
                  }

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filtersContacts.length,
                          itemBuilder: (BuildContext context, int index) {
                            final contact = filtersContacts[index];
                            return ContactItem(
                              contact: contact,
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
