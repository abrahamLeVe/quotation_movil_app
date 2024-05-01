import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pract_01/models/payment/get_all_payment.dart';
import 'package:pract_01/screens/payment/payment_actions.dart';
import 'package:pract_01/services/mercado_pago_service.dart';
import 'package:pract_01/widgets/payment/payment_invoice.dart';
import 'package:pract_01/utils/date_utils.dart' as util_format;

class PaymentItem extends StatelessWidget {
  final Payment payment;

  const PaymentItem({
    Key? key,
    required this.payment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isCotizacionIncomplete = payment.attributes.cotizacion.data == null;
    String cotizacionId =
        payment.attributes.cotizacion.data?.id.toString() ?? 'ID no disponible';

    BoxDecoration boxDecoration = isCotizacionIncomplete
        ? BoxDecoration(
            border: Border.all(color: Colors.red, width: 2),
            borderRadius: BorderRadius.circular(10),
          )
        : payment.attributes.status == "in_process"
            ? BoxDecoration(
                border: Border.all(color: Colors.amber, width: 2),
                borderRadius: BorderRadius.circular(10),
              )
            : BoxDecoration(
                border: Border.all(color: Colors.green, width: 2),
                borderRadius: BorderRadius.circular(10),
              );

    return Container(
      decoration: boxDecoration,
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text(
          'Pago ID: ${payment.attributes.paymentId}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cotización ID: $cotizacionId'),
            Text(
              'Status: ${payment.attributes.status.toUpperCase()}',
              style: TextStyle(
                color: payment.attributes.status == "approved"
                    ? Colors.green
                    : Colors.amber,
              ),
            ),
            Text(
              'Creado: ${util_format.DateUtils.formatCreationDate(payment.attributes.createdAt.toString())}',
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (payment.attributes.status == "in_process")
              IconButton(
                icon: const Icon(Icons.check_circle_outline_outlined,
                    color: Colors.green),
                onPressed: () {
                  aprovePayment(
                      context,
                      payment.id,
                      payment.attributes.cotizacion.data!.id,
                      payment.attributes.user.data.id,
                      'approved',
                      payment.attributes.publishedAt.toIso8601String());
                },
                tooltip: 'Aprobar pago',
              ),
            if (payment.attributes.status == "in_process")
              IconButton(
                icon: const Icon(Icons.cancel_outlined, color: Colors.red),
                onPressed: () {
                  aprovePayment(
                      context,
                      payment.id,
                      payment.attributes.cotizacion.data!.id,
                      payment.attributes.user.data.id,
                      'cancelled',
                      payment.attributes.publishedAt.toIso8601String());
                },
                tooltip: 'Anular pago',
              ),
            IconButton(
              icon: const Icon(Icons.cloud_download),
              onPressed: () {
                downloadInvoice(context, payment);
              },
              tooltip: 'Descargar factura',
            ),
            if (payment.attributes.status == "approved")
              IconButton(
                icon: const Icon(Icons.archive),
                onPressed: () {
                  if (!isCotizacionIncomplete) {
                    archivePayment(context, payment.id,
                        payment.attributes.cotizacion.data!.id);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'No se puede archivar sin una cotización completa.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                tooltip: 'Archivar pago',
              ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // Llama a la función para consultar por el ID del pago
                _showPaymentDetailsDialog(
                    context, payment.attributes.paymentId);
              },
              tooltip: 'Consultar pago por ID',
            ),
          ],
        ),
      ),
    );
  }

  // Función para mostrar los detalles del pago en un diálogo
  Future<void> _showPaymentDetailsDialog(
      BuildContext context, String paymentId) async {
    try {
      // Consultar los detalles del pago por su ID utilizando el servicio MercadoPagoService
      final paymentDetails = await MercadoPagoService(context: context)
          .getPayMPDetails(int.parse(paymentId));

      // Mostrar los detalles del pago en un diálogo
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Detalles del Pago'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ID del Pago: ${paymentDetails['id']}'),
                    Text('Estado: ${paymentDetails['status']}'),
                    Text(
                        'Dettalle de estado: ${paymentDetails['status_detail']}'),
                    Text('Monto: ${paymentDetails['transaction_amount']}'),
                    const Text('Metodo de pago:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('id: ${paymentDetails['payment_method']["id"]}'),
                    Text('type: ${paymentDetails['payment_method']["type"]}'),

                    // Muestra más detalles del pago según sea necesario...
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cierra el diálogo
                  },
                  child: const Text('Cerrar'),
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error al mostrar los detalles del pago: $error');
      }
      // Manejar cualquier error que ocurra al obtener los detalles del pago
      // Por ejemplo, puedes mostrar un mensaje de error al usuario
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al obtener los detalles del pago'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

// Función auxiliar para construir un elemento de detalle del pago
//   Widget _buildDetailItem(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
//           Text(value),
//         ],
//       ),
//     );
//   }
}
