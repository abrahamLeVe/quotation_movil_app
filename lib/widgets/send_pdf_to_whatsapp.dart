import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SendPdfToWhatsAppButton extends StatelessWidget {
  final String phoneNumber;
  final String pdfFilePath;
  final int code;
  final String customerName;

  SendPdfToWhatsAppButton({
    Key? key,
    required this.phoneNumber,
    required this.pdfFilePath,
    required this.code,
    required this.customerName,
  }) : super(key: key) {
    _sendToWhatsApp();
  }

  Future<void> _sendToWhatsApp() async {
    final encodedUrl = Uri.encodeFull(pdfFilePath);
    final encodedMessage = Uri.encodeComponent(
        'Estimado Cliente: $customerName\n\n'
        'Es grato saludarlo y a la vez confirmarle la recepción de su cotización, por favor enviar el número de RUC y Razón Social de su empresa; en caso de ser a nombre de persona natural favor de indicarnos su número de DNI y la dirección de su domicilio para poder ser registrado en nuestra base.\n\n'
        'Nota:\n'
        '*Es importante que nos envíe sus números telefónicos para poder contactarnos con ustedes, y dirección de su empresa para poder registrarlo en nuestro sistema.\n'
        '** Por indicaciones de SUNAT todo registro de clientes debe contar con su respectiva dirección fiscal para una eventual emisión de comprobante de pago.\n\n'
        'Adjunto datos de la cotización:\n'
        'Código: $code\n'
        'Recibo: $encodedUrl\n\n'
        'Empresa de importación y venta de materiales eléctricos para transformadores CONSORCIO A&C ELÉCTRICA S.A.C.\n'
        'RUC: 2060342527\n'
        'Cel: 948125398\n'
        'Correo: consorcio.electrica.sac@gmail.com\n\n'
        'Atentamente,\n'
        'Call Center Ventas');

    final Uri url = Uri.parse(
        'whatsapp://send?phone=$phoneNumber&text=$encodedMessage');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const ElevatedButton(
      onPressed: null,
      child: Text('Enviar por WhatsApp'),
    );
  }
}
