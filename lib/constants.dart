import 'package:flutter_dotenv/flutter_dotenv.dart';

String get host => dotenv.env['HOST'] ?? 'https://dummyjson.com';
const String appSubtitle = 'Browse Our Products';
