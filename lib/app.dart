import 'package:flutter/material.dart';

import 'screens/main_navigation.dart';
import 'theme/app_theme.dart';

class PanierDeSaisonApp extends StatelessWidget {
  const PanierDeSaisonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Panier de Saison',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const MainNavigation(),
    );
  }
}

// Garde une compatibilite avec l'ancien test et d'eventuels imports locaux.
class KemetExplorerApp extends PanierDeSaisonApp {
  const KemetExplorerApp({super.key});
}
