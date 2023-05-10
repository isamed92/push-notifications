import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String androidApiKey =
      dotenv.env['ANDROID_API_KEY'] ?? 'API KEY DOES NOT EXISTS';
  static String iosApiKey =
      dotenv.env['IOS_API_KEY'] ?? 'API KEY DOES NOT EXISTS';
}
