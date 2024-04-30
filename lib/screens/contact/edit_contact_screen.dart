import 'package:flutter/material.dart';
import 'package:pract_01/models/contact/get_all_contact.dart';
import 'package:pract_01/providers/contact_state.dart';
import 'package:pract_01/services/contact_service.dart';
import 'package:pract_01/utils/date_utils.dart';
import 'package:pract_01/utils/dialog_utils.dart';

import 'package:provider/provider.dart';

class ContactScreen extends StatefulWidget {
  final Contact contact;

  const ContactScreen({Key? key, required this.contact}) : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final TextEditingController _responseController = TextEditingController();
  bool showApproveButton = false;
  String responseAprov = "";
  bool isTestimonyApproved = false;
  bool _isSending = false;
  bool _sendSuccess = false;

  @override
  void initState() {
    super.initState();
    _responseController.text = widget.contact.attributes.responseContact ?? '';
    showApproveButton =
        widget.contact.attributes.contactType.data.attributes.name ==
            "Testimonio";
  }

  Future<void> _sendResponse() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Envío'),
          content: const Text(
              '¿Estás seguro de que deseas enviar y archivar este mensaje?'),
          actions: <Widget>[
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(Icons.warning_amber_rounded,
                      color: Colors.amber,
                      size: 50), // Tamaño del icono ajustado a 30
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text('No'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: const Text('Sí'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );

    if (confirm != true) {
      return;
    }

    setState(() {
      _isSending = true;
    });

    try {
      if (mounted) {
        showLoadingDialog(context);
        Map<String, dynamic> updateData = {
          "data": {
            "id": widget.contact.id,
            "responseContact": _responseController.text,
            "stateMessage": isTestimonyApproved,
            "publishedAt":
                isTestimonyApproved ? DateTime.now().toIso8601String() : null,
          }
        };
        await ContactService(context: context)
            .updateContactService(widget.contact.id, updateData);
        if (mounted) {
          Provider.of<ContactState>(context, listen: false)
              .loadNewContacts(context);

          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Mensaje enviado con éxito.")));
        }
        setState(() {
          _sendSuccess = true;
          _isSending = false;
        });
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error al enviar: ${error.toString()}")));
      }

      setState(() {
        _sendSuccess = false;
        _isSending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool showApproveSwitch =
        widget.contact.attributes.contactType.data.attributes.name ==
            "Testimonio";
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de contacto ID N° ${widget.contact.id}'),
        backgroundColor: Colors.deepPurple,
        titleTextStyle:
            const TextStyle(color: Colors.white), // Establece el estilo aquí
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailItem('Tipo de mensaje',
                widget.contact.attributes.contactType.data.attributes.name),
            _buildDetailItem('Nombre', widget.contact.attributes.name),
            _buildDetailItem(
                'Correo electrónico', widget.contact.attributes.email),
            _buildDetailItem('Teléfono', widget.contact.attributes.phone),
            _buildDetailItem(
                'Título del mensaje', widget.contact.attributes.title),
            _buildDetailItem('Mensaje', widget.contact.attributes.message),
            _buildDetailItem(
                'Fecha de creación',
                DateFacUtils.formatCreationDate(
                    widget.contact.attributes.createdAt.toString())),
            _buildDetailItem(
                'Rating', widget.contact.attributes.rating.toString()),
            if (showApproveSwitch)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Aprobar Testimonio',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple[700],
                        ),
                      ),
                    ),
                    Switch(
                      value: isTestimonyApproved,
                      onChanged: (value) {
                        setState(() {
                          isTestimonyApproved = value;
                        });
                      },
                      activeColor: Colors.green,
                    ),
                  ],
                ),
              ),
            TextField(
              controller: _responseController,
              decoration: const InputDecoration(
                labelText: 'Respuesta (opcional)',
                border: OutlineInputBorder(),
                fillColor: Colors.white10,
                filled: true,
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 20),
            Center(
              child: _sendSuccess
                  ? ElevatedButton.icon(
                      icon: const Icon(Icons.check, color: Colors.white),
                      label: const Text('Mensaje enviado con éxito',
                          style: TextStyle(color: Colors.white)),
                      onPressed: null, // Desactiva el botón
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // Indica éxito
                      ),
                    )
                  : ElevatedButton.icon(
                      icon: const Icon(Icons.send_and_archive,
                          color: Colors.white),
                      label: const Text('Enviar y archivar',
                          style: TextStyle(color: Colors.white)),
                      onPressed: _isSending
                          ? null
                          : _sendResponse, // Desactiva durante el envío
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple[700],
              ),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
