import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:renote/providers/note_provider.dart';
import 'package:renote/screens/home_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:renote/services/hive_service.dart';
import 'package:renote/services/settings_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  await SettingsService().init();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NoteProvider()),
        ChangeNotifierProvider(create: (_) => SettingsService()),
      ],

      child: Consumer<SettingsService>(
        builder: (context, settingsService, _) {
          return DynamicColorBuilder(
            builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
              return MaterialApp(
                localizationsDelegates: [
                  GlobalMaterialLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  FlutterQuillLocalizations.delegate,
                ],
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  useMaterial3: true,
                  colorScheme: settingsService.dynamicMode
                      ? lightDynamic
                      : ColorScheme.fromSeed(
                          seedColor: Colors.amberAccent,
                          brightness: Brightness.light,
                        ),
                  fontFamily: GoogleFonts.poppins().fontFamily,
                ),
                darkTheme: ThemeData(
                  useMaterial3: true,
                  colorScheme: settingsService.dynamicMode
                      ? darkDynamic
                      : ColorScheme.fromSeed(
                          seedColor: Colors.amberAccent,
                          brightness: Brightness.dark,
                        ),
                  fontFamily: GoogleFonts.poppins().fontFamily,
                ),
                themeMode: settingsService.darkMode == null
                    ? ThemeMode.system
                    : settingsService.darkMode == true
                    ? ThemeMode.dark
                    : ThemeMode.light,
                home: HomeScreen(),
              );
            },
          );
        },
      ),
    );
  }
}
