import 'package:flutter/material.dart';
import 'package:pract_01/models/contact/get_all_contact.dart';
import 'package:pract_01/screens/contact/edit_contact_screen.dart';
import 'package:pract_01/utils/date_utils.dart' as util_format;

class ContactItem extends StatelessWidget {
  final Contact contact;

  const ContactItem({
    Key? key,
    required this.contact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        title: Text(
          'Contact ID: ${contact.id}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tipo: ${contact.attributes.contactType.data.attributes.name}',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Creado el: ${util_format.DateUtils.formatCreationDate(contact.attributes.createdAt.toString())}',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: Wrap(
          spacing: 12, // Espacio entre cada botón
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContactScreen(contact: contact),
                    ));
              },
              tooltip: 'Editar contacto',
            ),
          ],
        ),
      ),
    );
  }
}
