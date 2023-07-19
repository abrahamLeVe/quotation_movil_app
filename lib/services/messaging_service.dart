import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pract_01/providers/quotation_state.dart';
import 'package:pract_01/services/quotation_service.dart';
import 'package:provider/provider.dart';

typedef MessageReceivedCallback = void Function(RemoteMessage message);

class MessagingService {
  MessageReceivedCallback? onMessageReceived;
  static String? fcmToken; // Variable to store the FCM token

  static final MessagingService _instance = MessagingService._internal();

  factory MessagingService() => _instance;

  MessagingService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> init(BuildContext context) async {
    // Requesting permission for notifications
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint(
        'User granted notifications permission: ${settings.authorizationStatus}');

    // Retrieving the FCM token
    fcmToken = await _fcm.getToken();
    log('fcmToken: $fcmToken');

    // Handling background messages using the specified handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Listening for incoming messages while the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.notification!.title.toString()}');

      if (message.notification != null) {
        if (message.notification!.title != null &&
            message.notification!.body != null) {
          final notificationData = message.data;

          // Showing an alert dialog when a notification is received (Foreground state)
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return WillPopScope(
                onWillPop: () async => false,
                child: AlertDialog(
                  title: Text(message.notification!.title!),
                  content: Text(message.notification!.body!),
                  actions: [
                    if (notificationData.containsKey('screen'))
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _handleNotificationClick(
                              context, message); // Llamar al método aquí
                        },
                        child: const Text('Ver cotización'),
                      ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Dismiss'),
                    ),
                  ],
                ),
              );
            },
          );
        }
      }
    });

    // Handling the initial message received when the app is launched from dead (killed state)
    // When the app is killed and a new notification arrives when user clicks on it
    // It gets the data to which screen to open
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _handleNotificationClick(context, message); // Llamar al método aquí
      }
    });

    // Handling a notification click event when the app is in the background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint(
          'onMessageOpenedApp: ${message.notification!.title.toString()}');
      _handleNotificationClick(context, message); // Llamar al método aquí
    });
  }

  void _handleNotificationClick(BuildContext context, RemoteMessage message) {
    final quotationState = Provider.of<QuotationState>(context, listen: false);
    quotationState.setQuotations(
        []); // Vaciar las cotizaciones antes de cargarlas nuevamente
    _loadQuotations(context, message); // Pasar el mensaje como argumento
  }

  Future<void> _loadQuotations(
      BuildContext context, RemoteMessage message) async {
    final quotationState = Provider.of<QuotationState>(context, listen: false);

    // Verificar si las cotizaciones ya se están cargando
    if (quotationState.areQuotationsLoaded) {
      return;
    }

    quotationState.setAreQuotationsLoaded(true); // Marcar como cargando

    final result = await QuotationService().getAllQuotation();
    quotationState.setQuotations(result.data);

    quotationState.setAreQuotationsLoaded(false); // Marcar como no cargando
  }
}

// Handler for background messages
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  debugPrint('Handling a background message: ${message.notification!.title}');
}
