import 'dart:async';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pract_01/providers/quotation_state.dart';
import 'package:pract_01/screens/quotation/quotation_actions.dart';
import 'package:pract_01/services/quotation_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

typedef MessageReceivedCallback = void Function(RemoteMessage message);

class MessagingService {
  Function()? onNotificationAccepted;
  MessageReceivedCallback? onMessageReceived;
  static String? fcmToken;
  // ignore: unused_field
  late QuotationState _quotationState;

  static final MessagingService _instance = MessagingService._internal();
  factory MessagingService() => _instance;
  MessagingService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  bool _isDialogOpen = false;
  final List<RemoteMessage> _queuedMessages = [];
  final StreamController<void> _quotationsUpdatedController =
      StreamController<void>.broadcast();

  Stream<void> get onQuotationsUpdated => _quotationsUpdatedController.stream;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void setOnNotificationAcceptedCallback(Function() callback) {
    onNotificationAccepted = callback;
  }

  Future<void> init(BuildContext context) async {
    await _initializeQuotationState(context);
    await _requestNotificationPermission();
    await _retrieveFcmToken();
    // ignore: use_build_context_synchronously
    _setupFirebaseListeners(context);
    await _initializeLocalNotifications();
  }

  Future<void> _initializeQuotationState(BuildContext context) async {
    _quotationState = Provider.of<QuotationState>(context, listen: false);
  }

  Future<void> _requestNotificationPermission() async {
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
  }

  Future<void> _retrieveFcmToken() async {
    fcmToken = await _fcm.getToken();
    log('fcmToken: $fcmToken');
  }

  void _setupFirebaseListeners(BuildContext context) {
    updateQuotationsInBackground(context);

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleForegroundMessage(context, message);
    });
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _handleNotificationClick(context, message);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationClick(context, message);
    });
  }

  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _handleForegroundMessage(BuildContext context, RemoteMessage message) {
    if (_shouldProcessMessage(message)) {
      _showNotificationDialog(context, message);
      _showLocalNotification(
        message.notification!.title!,
        message.notification!.body!,
      );
      _processQueuedNotifications(context);
    } else {
      _queuedMessages.add(message);
    }
    _quotationsUpdatedController.add(null);
  }

  bool _shouldProcessMessage(RemoteMessage message) {
    return message.notification != null &&
        message.notification!.title != null &&
        message.notification!.body != null &&
        !_isDialogOpen;
  }

  Future<void> _showLocalNotification(String title, String body) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }

  void _handleNotificationClick(BuildContext context, RemoteMessage message) {
    final quotationState = Provider.of<QuotationState>(context, listen: false);

    if (!_isLoadingQuotations && !quotationState.areQuotationsLoaded) {
      _loadQuotations(context, message);
    } else if (!_isLoadingQuotations &&
        quotationState.areQuotationsLoaded &&
        !_isDialogOpen) {
      _queuedNotifications.add(message);
      _isDialogOpen = true;
      _processQueuedNotifications(context);
    } else if (!_isLoadingQuotations &&
        quotationState.areQuotationsLoaded &&
        _isDialogOpen) {
      _queuedNotifications.add(message);
    }
  }

  void _processQueuedNotifications(BuildContext context) {
    if (_queuedNotifications.isNotEmpty) {
      final nextMessage = _queuedNotifications.removeAt(0);
      _loadQuotations(context, nextMessage);
    } else {
      _isDialogOpen = false;
    }
  }

  void _showNotificationDialog(BuildContext context, RemoteMessage message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            title: Text(message.notification!.title!),
            content: Text(message.notification!.body!),
            actions: [
              if (message.data.containsKey('screen'))
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _isDialogOpen = false; // Marca el diálogo como cerrado
                    _handleNotificationClick(context, message);
                    if (onNotificationAccepted != null) {
                      onNotificationAccepted!();
                    }
                  },
                  child: const Text('Confirmar'),
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

  bool _isLoadingQuotations = false;
  final List<RemoteMessage> _queuedNotifications = [];

  Future<void> _loadQuotations(
      BuildContext context, RemoteMessage message) async {
    final quotationState = Provider.of<QuotationState>(context, listen: false);

    if (_isLoadingQuotations || quotationState.areQuotationsLoaded) {
      _queuedNotifications.add(message);
      return;
    }

    _isLoadingQuotations = true;

    try {
      final result =
          await QuotationService(context: context).getAllQuotation(1);
      quotationState.setQuotations(result.data);
    } catch (error) {
      debugPrint('Error al cargar las cotizaciones: $error');
    } finally {
      _isLoadingQuotations = false;

      if (_queuedNotifications.isNotEmpty) {
        final nextMessage = _queuedNotifications.removeAt(0);
        // ignore: use_build_context_synchronously
        _loadQuotations(context, nextMessage);
      }
    }
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint(
      'Handling a Segundo plano message: ${message.notification!.title}  ${message.notification!.body}');
}
