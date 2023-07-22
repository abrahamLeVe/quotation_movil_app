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
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  bool _isDialogOpen = false;
  final List<RemoteMessage> _queuedMessages = [];

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
          if (!_isDialogOpen) {
            _isDialogOpen = true;
            _showNotificationDialog(context, message);
          } else {
            // If a dialog is already open, queue the message
            _queuedMessages.add(message);
          }
        }
      }
    });

    // Handling the initial message received when the app is launched from dead (killed state)
    // When the app is killed and a new notification arrives when the user clicks on it
    // It gets the data to which screen to open
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _handleNotificationClick(context, message); // Call the method here
      }
    });

    // Handling a notification click event when the app is in the background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint(
          'onMessageOpenedApp: ${message.notification!.title.toString()}');
      _handleNotificationClick(context, message); // Call the method here
    });
  }

  void _handleNotificationClick(BuildContext context, RemoteMessage message) {
    final quotationState = Provider.of<QuotationState>(context, listen: false);
    quotationState
        .setQuotations([]); // Empty the quotations before loading them again
    _loadQuotations(context, message); // Pass the message as an argument

    if (_isDialogOpen) {
      _navigatorKey.currentState?.pop();
      _isDialogOpen = false;
    }
  }

  void _showNotificationDialog(BuildContext context, RemoteMessage message) {
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
              if (message.data.containsKey('screen'))
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _handleNotificationClick(context, message);
                  },
                  child: const Text('Ver cotización'),
                ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _isDialogOpen = false;
                  if (_queuedMessages.isNotEmpty) {
                    final nextMessage = _queuedMessages.removeAt(0);
                    _showNotificationDialog(context, nextMessage);
                  }
                },
                child: const Text('Dismiss'),
              ),
            ],
          ),
        );
      },
    );
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
