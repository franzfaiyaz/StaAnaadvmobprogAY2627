import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';

// Enhancement 3: Settings page with dark/light mode switch.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark mode'),
            subtitle: const Text('Toggle between light and dark theme'),
            value: themeProvider.isDark,
            onChanged: themeProvider.toggleTheme,
          ),
        ],
      ),
    );
  }
}
