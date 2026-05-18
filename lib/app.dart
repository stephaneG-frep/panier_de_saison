import 'package:flutter/material.dart';

import 'screens/main_navigation.dart';
import 'theme/app_theme.dart';

class ThemeController {
  static final ValueNotifier<ThemeMode> mode = ValueNotifier(ThemeMode.light);

  static void toggle() {
    mode.value = mode.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  }
}

class PanierDeSaisonApp extends StatefulWidget {
  const PanierDeSaisonApp({super.key});

  @override
  State<PanierDeSaisonApp> createState() => _PanierDeSaisonAppState();
}

class _PanierDeSaisonAppState extends State<PanierDeSaisonApp> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.mode,
      builder: (context, themeMode, _) => MaterialApp(
        title: 'Panier de Saison',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeMode,
        home: MainNavigation(
          themeMode: themeMode,
          onToggleThemeMode: ThemeController.toggle,
        ),
      ),
    );
  }
}

// Garde une compatibilite avec l'ancien test et d'eventuels imports locaux.
class KemetExplorerApp extends PanierDeSaisonApp {
  const KemetExplorerApp({super.key});
}
