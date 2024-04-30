import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pract_01/models/contact/get_all_contact.dart';
import 'package:pract_01/services/contact_service.dart';
import 'package:provider/provider.dart';

class ContactState with ChangeNotifier {
  List<Contact> _contacts = [];
  List<Contact> _originalContacts = [];
  int _contactsCount = 0;
  bool _areContactsLoaded = false;

  List<Contact> get contacts => _contacts;
  int get productsCount => _contactsCount;
  bool get areContactsLoaded => _areContactsLoaded;
  bool newNotificationAvailable = false;
  bool isNewNotificationAvailable() {
    if (newNotificationAvailable) {
      newNotificationAvailable = false;
      return true;
    }
    return false;
  }

  // En ContactState
  void loadNewContacts(BuildContext context) async {
    try {
      ContactService service =
          Provider.of<ContactService>(context, listen: false);
      ContactModel newContacts = await service.getContactAll();

      // Actualiza el estado con los nuevos contactos
      setContacts(newContacts.data);
      setAreContactsLoaded(true);
    } catch (e) {
      if (kDebugMode) {
        print('Error al cargar nuevos contactos: $e');
      }
      setAreContactsLoaded(false);
    }
  }

  set contacts(List<Contact> newContacts) {
    _contacts = newContacts;
    notifyListeners();
  }

  void addContact(Contact contact) {
    _contacts.add(contact);
    notifyListeners();
  }

  void setContactsCount(int count) {
    _contactsCount = count;
    notifyListeners();
  }

  void updateContact(Contact updatedContact) {
    int index = _contacts.indexWhere((p) => p.id == updatedContact.id);
    if (index != -1) {
      _contacts[index] = updatedContact;
      notifyListeners();
    }
  }

  void setAreContactsLoaded(bool value) {
    _areContactsLoaded = value;
    notifyListeners();
  }

  void setContacts(List<Contact> contacts) {
    _contacts = contacts;
    _originalContacts = List<Contact>.from(contacts);
    setContactsCount(contacts.length);
    notifyListeners();
  }

  void filterContacts(String searchText) {
    if (searchText.isEmpty) {
      _contacts = List<Contact>.from(_originalContacts);
    } else {
      final filteredContacts = _originalContacts.where((contact) {
        final code = contact.id.toString();
        return code.contains(searchText.toUpperCase());
      }).toList();

      _contacts = filteredContacts;
    }
    notifyListeners();
  }

  void updateContactsCount() {
    _contactsCount = _contacts.length;
    notifyListeners();
  }

  void removeContact(int contactId) {
    _contacts.removeWhere((contact) => contact.id == contactId);
    updateContactsCount();
    notifyListeners();
  }

  int get contactsCount => _contacts.length;
}
