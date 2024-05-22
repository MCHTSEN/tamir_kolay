import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiKeys {
  String iosFirebaseApi = dotenv.env["FIREBASE_IOS_API_KEY"] ?? '';
  String androidFirebaseApi = dotenv.env["FIREBASE_ANDROID_API_KEY"] ?? '';
  String macosFirebaseApi = dotenv.env["FIREBASE_MACOS_API_KEY"] ?? '';
  String webFirebaseApi = dotenv.env["FIREBASE_WEB_API_KEY"] ?? '';
}
