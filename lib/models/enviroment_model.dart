import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String get fileName {
    if (kReleaseMode) {
      return '.env.production';
    }
    return '.env.development';
  }

  static String get apiUrl {
    return dotenv.env['API_URL'] ?? 'API_URL not found';
  }

  static String get apiMercadoPagoUrl {
    return dotenv.env['MP_API_URL'] ?? 'MP_API_URL not found';
  }

  static String get mercadoPagoAccessToken {
    return dotenv.env['MP_ACCESS_TOKEN'] ?? 'MP_ACCESS_TOKEN not found';
  }

  static String get apiKey {
    return dotenv.env['API_KEY'] ?? 'API_KEY not found';
  }

  static String get fcmToken {
    return dotenv.env['FCM_TOKEN'] ?? 'FCM_TOKEN not found';
  }
}
