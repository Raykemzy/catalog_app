import 'package:flutter/material.dart';

class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.textDisabled,
    required this.divider,
    required this.success,
    required this.warning,
    required this.danger,
  });

  final Color textDisabled;
  final Color divider;
  final Color success;
  final Color warning;
  final Color danger;

  @override
  ThemeExtension<AppSemanticColors> copyWith({
    Color? textDisabled,
    Color? divider,
    Color? success,
    Color? warning,
    Color? danger,
  }) {
    return AppSemanticColors(
      textDisabled: textDisabled ?? this.textDisabled,
      divider: divider ?? this.divider,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
    );
  }

  @override
  ThemeExtension<AppSemanticColors> lerp(
    covariant ThemeExtension<AppSemanticColors>? other,
    double t,
  ) {
    if (other is! AppSemanticColors) return this;
    return AppSemanticColors(
      textDisabled:
          Color.lerp(textDisabled, other.textDisabled, t) ?? textDisabled,
      divider: Color.lerp(divider, other.divider, t) ?? divider,
      success: Color.lerp(success, other.success, t) ?? success,
      warning: Color.lerp(warning, other.warning, t) ?? warning,
      danger: Color.lerp(danger, other.danger, t) ?? danger,
    );
  }
}

class AppTheme {
  const AppTheme._();

  static const _radiusPill = 999.0;

  static ThemeData light() {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF4A4459),
      onPrimary: Color(0xFFFFFFFF),
      secondary: Color(0xFF625B71),
      onSecondary: Color(0xFFFFFFFF),
      error: Color(0xFFB3261E),
      onError: Color(0xFFFFFFFF),
      surface: Color(0xFFFFFBFE),
      onSurface: Color(0xFF1C1B1F),
      surfaceContainerHighest: Color(0xFFE6E0E9),
      onSurfaceVariant: Color(0xFF49454F),
      outline: Color(0xFFCAC4D0),
      shadow: Color(0xFF000000),
      inverseSurface: Color(0xFF313033),
      onInverseSurface: Color(0xFFF4EFF4),
      inversePrimary: Color(0xFFD0BCFF),
      surfaceTint: Color(0xFF4A4459),
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          height: 1.25,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          height: 1.33,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.43,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 1.4,
        ),
      ),
    );

    return base.copyWith(
      dividerColor: const Color(0x80CAC4D0),
      chipTheme: base.chipTheme.copyWith(
        shape: const StadiumBorder(),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
        labelStyle: base.textTheme.labelLarge,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radiusPill),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radiusPill),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radiusPill),
          borderSide: BorderSide(color: colorScheme.primary.withAlpha(56)),
        ),
      ),
      extensions: const [
        AppSemanticColors(
          textDisabled: Color(0x611C1B1F),
          divider: Color(0x80CAC4D0),
          success: Color(0xFF146C2E),
          warning: Color(0xFFB26A00),
          danger: Color(0xFFB3261E),
        ),
      ],
    );
  }

  static ThemeData dark() {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFD0BCFF),
      onPrimary: Color(0xFF2B203F),
      secondary: Color(0xFFCCC2DC),
      onSecondary: Color(0xFF332D41),
      error: Color(0xFFF2B8B5),
      onError: Color(0xFF601410),
      surface: Color(0xFF141218),
      onSurface: Color(0xFFE6E1E5),
      surfaceContainerHighest: Color(0xFF2B2930),
      onSurfaceVariant: Color(0xFFCAC4D0),
      outline: Color(0xFF49454F),
      shadow: Color(0xFF000000),
      inverseSurface: Color(0xFFE6E1E5),
      onInverseSurface: Color(0xFF313033),
      inversePrimary: Color(0xFF6750A4),
      surfaceTint: Color(0xFFD0BCFF),
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          height: 1.25,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          height: 1.33,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.43,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 1.4,
        ),
      ),
    );

    return base.copyWith(
      dividerColor: const Color(0x8049454F),
      chipTheme: base.chipTheme.copyWith(
        shape: const StadiumBorder(),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
        labelStyle: base.textTheme.labelLarge,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radiusPill),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radiusPill),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radiusPill),
          borderSide: BorderSide(color: colorScheme.primary.withAlpha(71)),
        ),
      ),
      extensions: const [
        AppSemanticColors(
          textDisabled: Color(0x61E6E1E5),
          divider: Color(0x8049454F),
          success: Color(0xFF7BD88F),
          warning: Color(0xFFFFC56B),
          danger: Color(0xFFF2B8B5),
        ),
      ],
    );
  }
}

class AppSpacing {
  const AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
}

class AppRadius {
  const AppRadius._();

  static const double xs = 6;
  static const double sm = 8;
  static const double md = 12;
  static const double pill = 999;
}
