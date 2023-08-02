import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pract_01/services/messaging/firebase_options.dart';

class FirebaseMessagingService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static bool _isInitialized = false;

  static Future<void> initializeFirebaseMessaging() async {
    if (!_isInitialized) {
       await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);
      _configureLocalNotifications();
      _configureFirebaseMessaging();
      _isInitialized = true;
    }
  }

  static void _configureLocalNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static void _configureFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showLocalNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Aquí puedes agregar la lógica para manejar la notificación cuando el usuario abre la aplicación desde la notificación
    });
  }

  static void _showLocalNotification(RemoteMessage message) {
    final notification = message.notification;
    final android = message.notification?.android;
    if (notification != null && android != null) {
      const channel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.high,
      );
      _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      final notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: 'app_icon',
        ),
      );

      _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        notificationDetails,
      );
    }
  }

  static Future<bool> isSubscribedToTopic(String topic) async {
    return _firebaseMessaging
        .subscribeToTopic(topic)
        .then((_) => true)
        .catchError((_) => false);
  }

  static Future<void> toggleSubscription(
      String topic, bool isSubscribed) async {
    if (isSubscribed) {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
    } else {
      await _firebaseMessaging.subscribeToTopic(topic);
    }
  }
}
