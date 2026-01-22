import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  AppTheme._();

  static const Color _primaryViolet = Color(0xFF9D7BEA);
  static const Color _secondaryLavender = Color(0xFFCBB8E8);
  static const Color _accentAmber = Color(0xFFE8A87C);
  static const Color _backgroundDark = Color(0xFF0C0B0F);
  static const Color _surfaceDark = Color(0xFF12111A);
  static const Color _surfaceContainer = Color(0xFF1C1A26);
  static const Color _surfaceContainerHigh = Color(0xFF26232F);
  static const Color _textPrimary = Color(0xFFF5F3FA);
  static const Color _textSecondary = Color(0xFFA8A3B8);
  static const Color _textTertiary = Color(0xFF6B6580);
  static const Color _accentRed = Color(0xFFE86B6B);

  static const List<Color> brandGradient = [
    _primaryViolet,
    _secondaryLavender,
    _accentAmber,
  ];

  static const List<Color> inputGradient = [
    Color(0xFF9D7BEA),
    Color(0xFFCBB8E8),
    Color(0xFFE8A87C),
  ];

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: _primaryViolet,
        onPrimary: Color(0xFF1A1225),
        primaryContainer: Color(0xFF3D2A5C),
        onPrimaryContainer: _primaryViolet,

        secondary: _secondaryLavender,
        onSecondary: Color(0xFF2A253D),
        secondaryContainer: Color(0xFF4A3D5C),
        onSecondaryContainer: _secondaryLavender,

        tertiary: _accentAmber,
        onTertiary: Color(0xFF3D2A15),
        tertiaryContainer: Color(0xFF5C4A2A),
        onTertiaryContainer: _accentAmber,

        error: _accentRed,
        onError: Color(0xFF3D1515),
        errorContainer: Color(0xFF5C2A2A),
        onErrorContainer: Color(0xFFFFB3B3),

        surface: _surfaceDark,
        onSurface: _textPrimary,
        surfaceContainerHighest: _surfaceContainerHigh,
        surfaceContainerHigh: _surfaceContainer,
        surfaceContainerLow: Color(0xFF15131D),
        surfaceContainerLowest: _backgroundDark,

        outline: Color(0xFF3D3849),
        outlineVariant: Color(0xFF2A2633),

        inverseSurface: Color(0xFFE8E5F0),
        onInverseSurface: Color(0xFF1A1A1A),
        inversePrimary: Color(0xFF6A4FAA),

        shadow: Colors.black,
        scrim: Colors.black,
      ),
      scaffoldBackgroundColor: _backgroundDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: _backgroundDark,
        foregroundColor: _textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: _surfaceDark,
        indicatorColor: _primaryViolet.withOpacity(0.2),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _primaryViolet,
            );
          }
          return const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: _textSecondary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: _primaryViolet);
          }
          return const IconThemeData(color: _textSecondary);
        }),
      ),
      cardTheme: CardThemeData(
        color: _surfaceContainer,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: Color(0xFF2A2633), width: 1),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _surfaceContainer,
          foregroundColor: _textPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Color(0xFF3D3849), width: 1),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _textPrimary,
          side: const BorderSide(color: Color(0xFF3D3849), width: 1),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _primaryViolet,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surfaceContainer,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF3D3849), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF3D3849), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _primaryViolet, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _accentRed, width: 1),
        ),
        hintStyle: const TextStyle(color: _textTertiary),
        labelStyle: const TextStyle(color: _textSecondary),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF2A2633),
        thickness: 1,
        space: 1,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: _surfaceContainer,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: Color(0xFF3D3849), width: 1),
        ),
        titleTextStyle: const TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w600,
          color: _textPrimary,
        ),
        contentTextStyle: const TextStyle(
          fontSize: 14,
          color: _textSecondary,
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: _surfaceContainer,
        modalBackgroundColor: _surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        ),
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: _surfaceDark,
        surfaceTintColor: Colors.transparent,
        width: 280,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: _surfaceContainer,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Color(0xFF3D3849), width: 1),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _surfaceContainerHigh,
        contentTextStyle: const TextStyle(color: _textPrimary),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 54,
          fontWeight: FontWeight.w400,
          color: _textPrimary,
          letterSpacing: -0.25,
        ),
        displayMedium: TextStyle(
          fontSize: 42,
          fontWeight: FontWeight.w400,
          color: _textPrimary,
        ),
        displaySmall: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w400,
          color: _textPrimary,
        ),
        headlineLarge: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w600,
          color: _textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w600,
          color: _textPrimary,
        ),
        headlineSmall: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: _textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: _textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: _textPrimary,
          letterSpacing: 0.1,
        ),
        titleSmall: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: _textPrimary,
          letterSpacing: 0.1,
        ),
        bodyLarge: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: _textPrimary,
          letterSpacing: 0.3,
        ),
        bodyMedium: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: _textPrimary,
          letterSpacing: 0.2,
        ),
        bodySmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: _textSecondary,
          letterSpacing: 0.3,
        ),
        labelLarge: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: _textPrimary,
          letterSpacing: 0.1,
        ),
        labelMedium: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: _textPrimary,
          letterSpacing: 0.4,
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: _textSecondary,
          letterSpacing: 0.4,
        ),
      ),
      iconTheme: const IconThemeData(
        color: _textPrimary,
        size: 22,
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: _textSecondary,
        textColor: _textPrimary,
        contentPadding: EdgeInsets.symmetric(horizontal: 14),
      ),
    );
  }

  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  static bool isMobile(BuildContext context) {
    return MediaQuery.sizeOf(context).width < mobileBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= tabletBreakpoint;
  }

  static EdgeInsets responsivePadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.symmetric(horizontal: 16);
    } else if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 24);
    }
    return const EdgeInsets.symmetric(horizontal: 32);
  }

  static double responsiveMaxWidth(BuildContext context) {
    if (isMobile(context)) {
      return double.infinity;
    } else if (isTablet(context)) {
      return 600;
    }
    return 500;
  }
}

extension GradientTextExtension on Text {
  Widget withGradient(List<Color> colors) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: colors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
      child: this,
    );
  }
}
