import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_planner_app/providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          return ListView(
            children: [
              SwitchListTile(
                title: const Text('Enable Reminders'),
                value: settingsProvider.remindersEnabled,
                onChanged: (value) {
                  settingsProvider.toggleReminders(value);
                },
              ),
              ListTile(
                title: const Text('Storage Method'),
                subtitle: Text(settingsProvider.storageMethod),
              ),
            ],
          );
        },
      ),
    );
  }
}
