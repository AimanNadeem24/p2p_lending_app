import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final Function(bool) onNotificationsChanged;
  final Function(bool) onBiometricChanged;
  final Function(String) onLanguageChanged;
  final Function() onPasswordChanged;

  final bool darkMode;
  final bool notificationsEnabled;
  final bool biometricLogin;
  final String language;

  const SettingsScreen({
    super.key,
    required this.onThemeChanged,
    required this.onNotificationsChanged,
    required this.onBiometricChanged,
    required this.onLanguageChanged,
    required this.onPasswordChanged,
    required this.darkMode,
    required this.notificationsEnabled,
    required this.biometricLogin,
    required this.language,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _darkMode;
  late bool _notificationsEnabled;
  late bool _biometricLogin;
  late String _language;

  @override
  void initState() {
    super.initState();
    _darkMode = widget.darkMode;
    _notificationsEnabled = widget.notificationsEnabled;
    _biometricLogin = widget.biometricLogin;
    _language = widget.language;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: const Color(0xFF1E3A8A),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text("Dark Mode"),
            value: _darkMode,
            activeThumbColor: const Color(0xFF1E3A8A),
            onChanged: (val) {
              setState(() => _darkMode = val);
              widget.onThemeChanged(val);
            },
          ),
          const Divider(),
          SwitchListTile(
            title: const Text("Enable Notifications"),
            value: _notificationsEnabled,
            activeThumbColor: const Color(0xFF1E3A8A),
            onChanged: (val) {
              setState(() => _notificationsEnabled = val);
              widget.onNotificationsChanged(val);
            },
          ),
          const Divider(),
          SwitchListTile(
            title: const Text("Biometric Login"),
            value: _biometricLogin,
            activeThumbColor: const Color(0xFF1E3A8A),
            onChanged: (val) {
              setState(() => _biometricLogin = val);
              widget.onBiometricChanged(val);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.lock, color: Color(0xFF1E3A8A)),
            title: const Text("Change Password"),
            onTap: () {
              widget.onPasswordChanged();
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.language, color: Color(0xFF1E3A8A)),
            title: const Text("Language"),
            subtitle: Text("Current: $_language"),
            onTap: () async {
              final selected = await showDialog<String>(
                context: context,
                builder: (ctx) => SimpleDialog(
                  title: const Text("Select Language"),
                  children: [
                    SimpleDialogOption(
                      onPressed: () => Navigator.pop(ctx, "English"),
                      child: const Text("English"),
                    ),
                    SimpleDialogOption(
                      onPressed: () => Navigator.pop(ctx, "Urdu"),
                      child: const Text("Urdu"),
                    ),
                  ],
                ),
              );
              if (selected != null) {
                setState(() => _language = selected);
                widget.onLanguageChanged(selected);
              }
            },
          ),
        ],
      ),
    );
  }
}
