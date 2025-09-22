import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:renote/services/settings_service.dart';
import 'package:renote/util.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsService _settingsService = SettingsService();

  @override
  void initState() {
    super.initState();
    // Listen to settings changes
    _settingsService.addListener(_onSettingsChanged);
  }

  @override
  void dispose() {
    _settingsService.removeListener(_onSettingsChanged);
    super.dispose();
  }

  void _onSettingsChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Uri url = Uri.parse('https://github.com/samvabya/renote');

    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Column(
        children: [
          SwitchListTile(
            value: _settingsService.dynamicMode,
            onChanged: _settingsService.setDynamicMode,
            title: Text('Dynamic Theme'),
            subtitle: Text('Match Wallpaper Color Scheme'),
          ),
          ListTile(
            title: Text('Theme Mode'),
            subtitle: Text('Match System Theme'),
            trailing: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Theme.of(context).colorScheme.onInverseSurface,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: DropdownButton<bool?>(
                items: [
                  DropdownMenuItem(value: false, child: Text('Light')),
                  DropdownMenuItem(value: true, child: Text('Dark')),
                  DropdownMenuItem(value: null, child: Text('System')),
                ],
                onChanged: _settingsService.setDarkMode,
                value: _settingsService.darkMode,
                underline: Container(),
                style: Theme.of(context).textTheme.bodySmall,
                borderRadius: BorderRadius.circular(20),
                dropdownColor: Theme.of(context).colorScheme.onInverseSurface,
              ),
            ),
          ),
          Divider(),
          ListTile(
            title: Text('Github Repo'),
            subtitle: Text(
              url.toString(),
              style: Theme.of(context).textTheme.labelSmall,
            ),
            trailing: Wrap(
              children: [
                IconButton.filledTonal(
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: 'https://github.com/samvabya/renote'),
                    );
                  },
                  icon: Icon(Icons.copy),
                ),
                IconButton.filledTonal(
                  onPressed: () async {
                    if (!await launchUrl(url)) {
                      showSnack('Cannot open link', context);
                    }
                  },
                  icon: Icon(Icons.open_in_new),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Stack(
              children: [
                Padding(
                  padding: EdgeInsetsGeometry.only(left: 10),
                  child: CircleAvatar(),
                ),
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://avatars.githubusercontent.com/u/127547778',
                  ),
                ),
              ],
            ),
            title: Text('Creators of renote'),
          ),
        ],
      ),
    );
  }
}
