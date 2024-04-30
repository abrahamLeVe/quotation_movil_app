import 'package:flutter/material.dart';
import 'package:pract_01/models/client/gat_all_client_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pract_01/providers/client_state.dart';

class ChartClientsScreen extends StatelessWidget {
  const ChartClientsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final allClients = Provider.of<ClientState>(context).clients;

    // Filtrar clientes con al menos una cotización exitosa
    final clientsWithSuccessQuotations = allClients.where((client) => client
        .quotations
        .any((quotation) => quotation.codeStatus == 'Cerrada'));

    // Convertir la lista filtrada a una lista ordenada por la cantidad de cotizaciones exitosas
    final sortedClients = clientsWithSuccessQuotations.toList()
      ..sort((a, b) => _getSuccessQuotationsCount(b)
          .compareTo(_getSuccessQuotationsCount(a)));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Informe de Clientes'),
      ),
      body: Container(
        // ignore: prefer_const_constructors
        padding: EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: sortedClients.length,
          itemBuilder: (context, index) {
            final client = sortedClients[index];

            return Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                title: Text(client.username),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Email: ${client.email}'),
                    Text(
                        'Cotizaciones Exitosas: ${_getSuccessQuotationsCount(client)}'),
                    // Agregar más detalles según sea necesario
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.phone),
                      onPressed: () =>
                          _makePhoneCall(client.quotations[0].phone),
                    ),
                    IconButton(
                      icon: const Icon(Icons.email),
                      onPressed: () => _sendEmail(client),
                    ),
                  ],
                ),
                onTap: () => _showClientDetails(context, client),
              ),
            );
          },
        ),
      ),
    );
  }

  // Método para calcular la cantidad de cotizaciones exitosas de un cliente
  int _getSuccessQuotationsCount(ClientModel client) {
    return client.quotations
        .where((quotation) => quotation.codeStatus == 'Cerrada')
        .length;
  }

  // Método para mostrar los detalles completos del cliente
  void _showClientDetails(BuildContext context, ClientModel client) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Detalles de ${client.username}'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Email: ${client.email}'),
              Text(
                  'Cotizaciones Exitosas: ${_getSuccessQuotationsCount(client)}'),
              // Agregar más detalles según sea necesario
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void _makePhoneCall(String phoneNumber) async {
    try {
      Uri email = Uri(
        scheme: 'tel',
        path: "+51$phoneNumber",
      );

      await launchUrl(email);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Método para enviar un correo electrónico
  void _sendEmail(ClientModel client) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: client.email,
    );

    launchUrl(emailLaunchUri);
  }
}
