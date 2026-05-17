import 'package:flutter/material.dart';

class AppTheme {
  static const sage = Color(0xFF7BA05B);
  static const cream = Color(0xFFFFF8E7);
  static const carrot = Color(0xFFF28C28);
  static const tomato = Color(0xFFD94F30);
  static const basket = Color(0xFF8B5E3C);
  static const darkGreen = Color(0xFF355E3B);

  static ThemeData get lightTheme => _theme(
    ColorScheme.fromSeed(
      seedColor: sage,
      brightness: Brightness.light,
    ).copyWith(
      primary: darkGreen,
      secondary: carrot,
      tertiary: basket,
      surface: cream,
    ),
  );

  static ThemeData get darkTheme => _theme(
    ColorScheme.fromSeed(
      seedColor: sage,
      brightness: Brightness.dark,
    ).copyWith(primary: sage, secondary: carrot, tertiary: basket),
  );

  static ThemeData _theme(ColorScheme scheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.brightness == Brightness.light
          ? cream
          : scheme.surface,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 22,
          fontWeight: FontWeight.w800,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        clipBehavior: Clip.antiAlias,
      ),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: sage.withValues(alpha: 0.22),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        ),
      ),
    );
  }
}
