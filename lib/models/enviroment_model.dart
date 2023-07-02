import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

String baseUrl = dotenv.get('API_URL', fallback: 'API_URL not found');
String token = dotenv.get('API_TOKEN', fallback: 'API_TOKEN not found');

class Enviroment {
  static String get fileName {
    if (kReleaseMode) {
      return '.env.production';
    }

    return '.env.development';
  }

  static String get apiUrl {
    return baseUrl;
  }

  static String get apiToken {
    return token;
  }
}
