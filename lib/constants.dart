import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

const String appName = 'Staana AdMob Prog';
const String appSubtitle = 'Sample product catalogue';

String get host {
  try {
    return dotenv.env['HOST'] ?? '';
  } catch (e) {
    return '';
  }
}

const Color primaryColor = Color(0xFF0066CC);
const Color accentColor = Color(0xFF00ADEF);
const Color backgroundColor = Color(0xFFF5F7FA);
