import 'dart:async';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pract_01/providers/contact_state.dart';
import 'package:pract_01/providers/payment_state.dart';
import 'package:pract_01/providers/quotation_state.dart';
import 'package:pract_01/services/messaging/fcm_token.dart';
import 'package:provider/provider.dart';

// Define un alias para el tipo de función de recepción de mensajes
typedef MessageReceivedCallback = void Function(RemoteMessage message);

class MessagingService {
  // Instancia única de la clase de servicio de mensajería
  static final MessagingService _instance = MessagingService._internal();
  factory MessagingService() => _instance;
  MessagingService._internal();

  // Controladores de transmisión para eventos de actualización de datos
  final StreamController<void> _quotationsUpdatedController =
      StreamController<void>.broadcast();
  final StreamController<void> _paymentsUpdatedController =
      StreamController<void>.broadcast();
  final StreamController<void> _contactsUpdatedController =
      StreamController<void>.broadcast();

  // Métodos para acceder a los streams de actualización de datos
  Stream<void> get onQuotationsUpdated => _quotationsUpdatedController.stream;
  Stream<void> get onPaymentsUpdated => _paymentsUpdatedController.stream;
  Stream<void> get onContactsUpdated => _contactsUpdatedController.stream;

  // Instancias de FirebaseMessaging y FlutterLocalNotificationsPlugin
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Método de inicialización del servicio
  Future<void> init(BuildContext context) async {
    await _requestNotificationPermission();
    await _retrieveFcmToken();
    await _initializeLocalNotifications();
    String? token = await _fcm.getToken();

    if (token != null) {
      if (context.mounted) {
        _setupFirebaseListeners(context);
        await FcmService(context: context).postFcmToken(token);
      }
    }
  }

  // Método para solicitar permiso de notificación
  Future<void> _requestNotificationPermission() async {
    NotificationSettings settings =
        await _fcm.requestPermission(alert: true, badge: true, sound: true);
    log('User granted notifications permission: ${settings.authorizationStatus}');
  }

  // Método para recuperar el token FCM
  Future<void> _retrieveFcmToken() async {
    String? token = await _fcm.getToken();
    log('FCM Token: $token');
  }

  // Configura los listeners de Firebase Messaging
  void _setupFirebaseListeners(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (context.mounted) {
        _handleForegroundMessage(context, message);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (context.mounted) {
        _processMessageBasedOnType(context, message);
      }
    });
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // Maneja los mensajes recibidos en primer plano
  void _handleForegroundMessage(BuildContext context, RemoteMessage message) {
    _showNotification(message.notification?.title ?? "No title",
        message.notification?.body ?? "No body");
    _processMessageBasedOnType(context, message);
  }

  // Muestra la notificación local
  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your channel id', 'your channel name',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, title, body, platformChannelSpecifics);
  }

  // Maneja el clic en la notificación
  void _processMessageBasedOnType(BuildContext context, RemoteMessage message) {
    final title = message.notification?.title ?? "";
    if (title.contains('cotización')) {
      Provider.of<QuotationState>(context, listen: false)
          .loadNewQuotations(context);
    } else if (title.contains('pago')) {
      Provider.of<PaymentState>(context, listen: false)
          .loadNewPayments(context);
    } else if (title.contains('mensaje')) {
      Provider.of<ContactState>(context, listen: false)
          .loadNewContacts(context);
    }
  }

  // Inicializa las notificaciones locales
  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('ic_launcher');
    const InitializationSettings settings =
        InitializationSettings(android: androidSettings);
    await flutterLocalNotificationsPlugin.initialize(settings);
  }

  // Maneja la selección de notificaciones
  Future onSelectNotification(String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    // Handle the notification action when you click on it
  }
}

// Método para manejar los mensajes en segundo plano
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log('Handling background message aqui: ${message.notification?.title}');
  // Handle data from background message
}
