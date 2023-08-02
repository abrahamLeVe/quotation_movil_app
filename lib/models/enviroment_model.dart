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

  static String get apiToken {
    return dotenv.env['API_TOKEN'] ?? 'API_TOKEN not found';
  }

  static String get apiMessageToken {
    return dotenv.env['MESSAGE_API_TOKEN'] ?? 'MESSAGE_API_TOKEN not found';
  }
}
