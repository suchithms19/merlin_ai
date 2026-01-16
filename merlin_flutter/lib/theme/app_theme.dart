import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  AppTheme._();
  static const Color _primaryTeal = Color(0xFF5FD4AA);
  static const Color _secondaryPeach = Color(0xFFE8B99D);
  static const Color _accentLavender = Color(0xFFB8A5C7);
  static const Color _backgroundDark = Color(0xFF000000);
  static const Color _surfaceDark = Color(0xFF0A0A0A);
  static const Color _surfaceContainer = Color(0xFF1A1A1A);
  static const Color _surfaceContainerHigh = Color(0xFF252525);
  static const Color _textPrimary = Color(0xFFFFFFFF);
  static const Color _textSecondary = Color(0xFFB0B0B0);
  static const Color _textTertiary = Color(0xFF707070);
  static const Color _accentRed = Color(0xFFFF6B6B);

  /// Gradient colors for the logo and accents
  static const List<Color> brandGradient = [
    _primaryTeal,
    _secondaryPeach,
    _accentLavender,
  ];

  /// Rainbow gradient for input field border
  static const List<Color> rainbowGradient = [
    Color(0xFFFF6B6B),
    Color(0xFFFFA94D),
    Color(0xFFFFE66D),
    Color(0xFF4ADE80),
    Color(0xFF4A9EFF),
    Color(0xFF9B5DE5),
  ];

  /// Get the dark theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: _primaryTeal,
        onPrimary: Color(0xFF003322),
        primaryContainer: Color(0xFF1A4D3A),
        onPrimaryContainer: _primaryTeal,

        secondary: _secondaryPeach,
        onSecondary: Color(0xFF3D2315),
        secondaryContainer: Color(0xFF5C3B2A),
        onSecondaryContainer: _secondaryPeach,

        tertiary: _accentLavender,
        onTertiary: Color(0xFF2D2539),
        tertiaryContainer: Color(0xFF4A3D5C),
        onTertiaryContainer: _accentLavender,

        error: _accentRed,
        onError: Color(0xFF3D1515),
        errorContainer: Color(0xFF5C2A2A),
        onErrorContainer: Color(0xFFFFB3B3),

        surface: _surfaceDark,
        onSurface: _textPrimary,
        surfaceContainerHighest: _surfaceContainerHigh,
        surfaceContainerHigh: _surfaceContainer,
        surfaceContainerLow: Color(0xFF121212),
        surfaceContainerLowest: _backgroundDark,

        outline: Color(0xFF3A3A3A),
        outlineVariant: Color(0xFF2A2A2A),

        inverseSurface: Color(0xFFE5E5E5),
        onInverseSurface: Color(0xFF1A1A1A),
        inversePrimary: Color(0xFF00785A),

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
        indicatorColor: _primaryTeal.withOpacity(0.2),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _primaryTeal,
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
            return const IconThemeData(color: _primaryTeal);
          }
          return const IconThemeData(color: _textSecondary);
        }),
      ),
      cardTheme: CardThemeData(
        color: _surfaceContainer,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF2A2A2A), width: 1),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _surfaceContainer,
          foregroundColor: _textPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFF3A3A3A), width: 1),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _textPrimary,
          side: const BorderSide(color: Color(0xFF3A3A3A), width: 1),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _primaryTeal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
          horizontal: 20,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3A3A3A), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3A3A3A), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryTeal, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _accentRed, width: 1),
        ),
        hintStyle: const TextStyle(color: _textTertiary),
        labelStyle: const TextStyle(color: _textSecondary),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF2A2A2A),
        thickness: 1,
        space: 1,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: _surfaceContainer,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF3A3A3A), width: 1),
        ),
        titleTextStyle: const TextStyle(
          fontSize: 20,
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
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: _surfaceDark,
        surfaceTintColor: Colors.transparent,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: _surfaceContainer,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFF3A3A3A), width: 1),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _surfaceContainerHigh,
        contentTextStyle: const TextStyle(color: _textPrimary),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 57,
          fontWeight: FontWeight.w400,
          color: _textPrimary,
          letterSpacing: -0.25,
        ),
        displayMedium: TextStyle(
          fontSize: 45,
          fontWeight: FontWeight.w400,
          color: _textPrimary,
        ),
        displaySmall: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w400,
          color: _textPrimary,
        ),
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: _textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: _textPrimary,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: _textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: _textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: _textPrimary,
          letterSpacing: 0.15,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: _textPrimary,
          letterSpacing: 0.1,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: _textPrimary,
          letterSpacing: 0.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: _textPrimary,
          letterSpacing: 0.25,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: _textSecondary,
          letterSpacing: 0.4,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: _textPrimary,
          letterSpacing: 0.1,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: _textPrimary,
          letterSpacing: 0.5,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: _textSecondary,
          letterSpacing: 0.5,
        ),
      ),
      iconTheme: const IconThemeData(
        color: _textPrimary,
        size: 24,
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: _textSecondary,
        textColor: _textPrimary,
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

  /// Responsive breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  /// Check if the screen is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.sizeOf(context).width < mobileBreakpoint;
  }

  /// Check if the screen is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  /// Check if the screen is desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= tabletBreakpoint;
  }

  /// Get responsive padding based on screen size
  static EdgeInsets responsivePadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.symmetric(horizontal: 16);
    } else if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 24);
    }
    return const EdgeInsets.symmetric(horizontal: 32);
  }

  /// Get responsive content max width
  static double responsiveMaxWidth(BuildContext context) {
    if (isMobile(context)) {
      return double.infinity;
    } else if (isTablet(context)) {
      return 600;
    }
    return 500;
  }
}

/// Extension for adding gradient text
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
