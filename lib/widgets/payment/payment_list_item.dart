import 'package:flutter/material.dart';
import 'package:pract_01/models/payment/get_all_payment.dart';
import 'package:pract_01/screens/payment/payment_actions.dart';
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
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: () {
                  downloadInvoice(context, payment);
                },
                child: const Icon(
                  Icons.cloud_download,
                  size: 35,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                archivePayment(context, payment.id,
                    payment.attributes.cotizacion.data!.id);
              },
              child: const Icon(
                Icons.archive,
                size: 35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
