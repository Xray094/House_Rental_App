import 'package:flutter/material.dart';

// Light Theme Colors
class LightThemeColors {
  // Primary Colors
  static const Color primaryBlue = Color(0xFF1E88E5);
  static const Color primaryBlueLight = Color(0xFF42A5F5);
  static const Color primaryBlueDark = Color(0xFF1565C0);

  // Background Colors
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color surfaceColor = Colors.white;
  static const Color cardColor = Colors.white;
  static const Color scaffoldBackgroundColor = Color(0xFFFAFAFA);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFF9E9E9E);

  // AppBar Colors
  static const Color appBarBackground = Colors.white;
  static const Color appBarTitleColor = Color(0xFF1E88E5);

  // Navigation Colors
  static const Color bottomNavigationBarBackground = Colors.white;
  static const Color bottomNavigationBarSelected = Color(0xFF1E88E5);
  static const Color bottomNavigationBarUnselected = Color(0xFF9E9E9E);

  // Input Colors
  static const Color inputFillColor = Color(0xFFF5F5F5);
  static const Color inputBorderColor = Color(0xFFE0E0E0);
  static const Color inputFocusedBorderColor = Color(0xFF1E88E5);

  // Button Colors
  static const Color buttonPrimary = Color(0xFF1E88E5);
  static const Color buttonPrimaryText = Colors.white;
  static const Color buttonSecondary = Color(0xFFF5F5F5);
  static const Color buttonSecondaryText = Color(0xFF212121);

  // Divider Color
  static const Color dividerColor = Color(0xFFE0E0E0);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  // Role Card Colors
  static const Color roleCardBackground = Colors.white;
  static const Color roleCardBorder = Color(0xFFE0E0E0);
  static const Color roleCardIcon = Color(0xFF757575);
  static const Color roleCardText = Color(0xFF212121);
}

// Dark Theme Colors
class DarkThemeColors {
  // Primary Colors (keeping same primary blue for brand consistency)
  static const Color primaryBlue = Color(0xFF1E88E5);
  static const Color primaryBlueLight = Color(0xFF42A5F5);
  static const Color primaryBlueDark = Color(0xFF1565C0);

  // Background Colors
  static const Color backgroundColor = Color(0xFF121212);
  static const Color surfaceColor = Color(0xFF1E1E1E);
  static const Color cardColor = Color(0xFF2C2C2C);
  static const Color scaffoldBackgroundColor = Color(0xFF121212);

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textHint = Color(0xFF808080);

  // AppBar Colors
  static const Color appBarBackground = Color(0xFF1E1E1E);
  static const Color appBarTitleColor = Color(0xFF1E88E5);

  // Navigation Colors
  static const Color bottomNavigationBarBackground = Color(0xFF1E1E1E);
  static const Color bottomNavigationBarSelected = Color(0xFF1E88E5);
  static const Color bottomNavigationBarUnselected = Color(0xFF9E9E9E);

  // Input Colors
  static const Color inputFillColor = Color(0xFF2C2C2C);
  static const Color inputBorderColor = Color(0xFF404040);
  static const Color inputFocusedBorderColor = Color(0xFF42A5F5);

  // Button Colors
  static const Color buttonPrimary = Color(0xFF1E88E5);
  static const Color buttonPrimaryText = Colors.white;
  static const Color buttonSecondary = Color(0xFF404040);
  static const Color buttonSecondaryText = Color(0xFFFFFFFF);

  // Divider Color
  static const Color dividerColor = Color(0xFF404040);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  // Role Card Colors
  static const Color roleCardBackground = Color(0xFF2C2C2C);
  static const Color roleCardBorder = Color(0xFF404040);
  static const Color roleCardIcon = Color(0xFFB0B0B0);
  static const Color roleCardText = Color(0xFFFFFFFF);
}

// Legacy support - keeping original primaryBlue for backward compatibility
final Color primaryBlue = const Color(0xFF1E88E5);
