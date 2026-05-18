import 'package:flutter/material.dart';

class AppTheme {
  static const sage = Color(0xFF4A6A3C);
  static const cream = Color(0xFFF4EBD7);
  static const carrot = Color(0xFFD97724);
  static const tomato = Color(0xFFB94B30);
  static const basket = Color(0xFF6E4A31);
  static const darkGreen = Color(0xFF2E4A34);
  static const leafNight = Color(0xFF1F2E22);
  static const mossNight = Color(0xFF2A3A2D);

  static ThemeData get lightTheme => _theme(
    ColorScheme.fromSeed(
      seedColor: sage,
      brightness: Brightness.light,
    ).copyWith(
      primary: darkGreen,
      secondary: carrot,
      error: tomato,
      tertiary: basket,
      surface: const Color(0xFFEDE0C4),
      surfaceContainerHighest: const Color(0xFFDFCFAF),
    ),
  );

  static ThemeData get darkTheme => _theme(
    ColorScheme.fromSeed(
      seedColor: darkGreen,
      brightness: Brightness.dark,
    ).copyWith(
      primary: const Color(0xFF7F9A63),
      secondary: const Color(0xFFE39A52),
      error: tomato,
      tertiary: const Color(0xFF9A6E4A),
      surface: leafNight,
      surfaceContainerHighest: mossNight,
    ),
  );

  static ThemeData _theme(ColorScheme scheme) {
    final isLight = scheme.brightness == Brightness.light;
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: 'Serif',
      scaffoldBackgroundColor: isLight ? const Color(0xFFE8D8B7) : scheme.surface,
      textTheme: ThemeData(brightness: scheme.brightness).textTheme.apply(
        bodyColor: scheme.onSurface,
        displayColor: scheme.onSurface,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: isLight ? 2 : 0,
        backgroundColor: isLight ? darkGreen : scheme.surface,
        foregroundColor: isLight ? cream : scheme.onSurface,
        titleTextStyle: TextStyle(
          color: isLight ? cream : scheme.onSurface,
          fontSize: 22,
          fontWeight: FontWeight.w800,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: isLight ? 2 : 1,
        shadowColor: scheme.primary.withValues(alpha: isLight ? 0.28 : 0.2),
        color: isLight ? const Color(0xFFF6EDDA) : scheme.surfaceContainerLowest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: isLight
              ? BorderSide(color: basket.withValues(alpha: 0.25), width: 1)
              : BorderSide.none,
        ),
        clipBehavior: Clip.antiAlias,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isLight ? darkGreen : scheme.surface,
        indicatorColor: scheme.secondary.withValues(alpha: isLight ? 0.34 : 0.24),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: isLight ? darkGreen : scheme.onSecondaryContainer);
          }
          return IconThemeData(color: isLight ? cream.withValues(alpha: 0.9) : scheme.onSurfaceVariant);
        }),
        labelTextStyle: WidgetStateProperty.all(
          TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 12,
            color: isLight ? cream : null,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withValues(
          alpha: isLight ? 0.72 : 0.55,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surfaceContainerHighest.withValues(
          alpha: isLight ? 0.78 : 0.6,
        ),
        labelStyle: TextStyle(
          color: scheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: isLight ? carrot : null,
          foregroundColor: isLight ? const Color(0xFF2C1A0E) : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: isLight ? carrot : scheme.secondary,
        foregroundColor: isLight ? const Color(0xFF2C1A0E) : scheme.onSecondary,
      ),
      iconTheme: IconThemeData(color: scheme.primary),
    );
  }
}
