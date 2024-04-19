import 'package:flutter/material.dart';
import 'package:pract_01/models/payment/get_all_payment.dart';
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
    return Card(
      child: ListTile(
        title: Row(
          children: [
            Text(
              'Código: ${payment.attributes.cotizacion.data!.id}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (payment.attributes.status == "approved")
              const Text(
                'Aprobado',
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
            Text(
              util_format.DateUtils.formatCreationDate(
                payment.attributes.createdAt.toString(),
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                downloadInvoice(context,
                    payment); // Aquí utilizamos el nombre correcto de la función
              },
              child: const Icon(Icons.edit),
            ),
          ],
        ),
      ),
    );
  }
}
