import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_rental_app/core/colors/color.dart';
import 'package:house_rental_app/core/controllers/theme_controller.dart';

extension ThemeExtensions on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  Color get primaryColor => Theme.of(this).primaryColor;
  Color get scaffoldBackgroundColor => Theme.of(this).scaffoldBackgroundColor;
  Color get cardColor => Theme.of(this).cardColor;
  Color get dividerColor => Theme.of(this).dividerColor;

  TextTheme get textTheme => Theme.of(this).textTheme;
  AppBarThemeData get appBarTheme => Theme.of(this).appBarTheme;
  BottomNavigationBarThemeData get bottomNavigationBarTheme =>
      Theme.of(this).bottomNavigationBarTheme;

  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  Color get primary => colorScheme.primary;
  Color get secondary => colorScheme.secondary;
  Color get surface => colorScheme.surface;
  Color get background => colorScheme.background;
  Color get error => colorScheme.error;
  Color get onPrimary => colorScheme.onPrimary;
  Color get onSecondary => colorScheme.onSecondary;
  Color get onSurface => colorScheme.onSurface;
  Color get onBackground => colorScheme.onBackground;
  Color get onError => colorScheme.onError;
}

extension AppColors on BuildContext {
  Color get currentBackgroundColor => isDark
      ? DarkThemeColors.backgroundColor
      : LightThemeColors.backgroundColor;

  Color get currentSurfaceColor =>
      isDark ? DarkThemeColors.surfaceColor : LightThemeColors.surfaceColor;

  Color get currentCardColor =>
      isDark ? DarkThemeColors.cardColor : LightThemeColors.cardColor;

  Color get currentTextPrimary =>
      isDark ? DarkThemeColors.textPrimary : LightThemeColors.textPrimary;

  Color get currentTextSecondary =>
      isDark ? DarkThemeColors.textSecondary : LightThemeColors.textSecondary;

  Color get currentTextHint =>
      isDark ? DarkThemeColors.textHint : LightThemeColors.textHint;

  Color get currentAppBarBackground => isDark
      ? DarkThemeColors.appBarBackground
      : LightThemeColors.appBarBackground;

  Color get currentAppBarTitleColor => isDark
      ? DarkThemeColors.appBarTitleColor
      : LightThemeColors.appBarTitleColor;

  Color get currentInputFillColor =>
      isDark ? DarkThemeColors.inputFillColor : LightThemeColors.inputFillColor;

  Color get currentInputBorderColor => isDark
      ? DarkThemeColors.inputBorderColor
      : LightThemeColors.inputBorderColor;

  Color get currentInputFocusedBorderColor => isDark
      ? DarkThemeColors.inputFocusedBorderColor
      : LightThemeColors.inputFocusedBorderColor;

  Color get currentButtonPrimary =>
      isDark ? DarkThemeColors.buttonPrimary : LightThemeColors.buttonPrimary;

  Color get currentButtonPrimaryText => isDark
      ? DarkThemeColors.buttonPrimaryText
      : LightThemeColors.buttonPrimaryText;

  Color get currentButtonSecondary => isDark
      ? DarkThemeColors.buttonSecondary
      : LightThemeColors.buttonSecondary;

  Color get currentButtonSecondaryText => isDark
      ? DarkThemeColors.buttonSecondaryText
      : LightThemeColors.buttonSecondaryText;

  Color get currentBottomNavigationBarBackground => isDark
      ? DarkThemeColors.bottomNavigationBarBackground
      : LightThemeColors.bottomNavigationBarBackground;

  Color get currentBottomNavigationBarSelected => isDark
      ? DarkThemeColors.bottomNavigationBarSelected
      : LightThemeColors.bottomNavigationBarSelected;

  Color get currentBottomNavigationBarUnselected => isDark
      ? DarkThemeColors.bottomNavigationBarUnselected
      : LightThemeColors.bottomNavigationBarUnselected;

  Color get currentDividerColor =>
      isDark ? DarkThemeColors.dividerColor : LightThemeColors.dividerColor;

  Color get currentRoleCardBackground => isDark
      ? DarkThemeColors.roleCardBackground
      : LightThemeColors.roleCardBackground;

  Color get currentRoleCardBorder =>
      isDark ? DarkThemeColors.roleCardBorder : LightThemeColors.roleCardBorder;

  Color get currentRoleCardIcon =>
      isDark ? DarkThemeColors.roleCardIcon : LightThemeColors.roleCardIcon;

  Color get currentRoleCardText =>
      isDark ? DarkThemeColors.roleCardText : LightThemeColors.roleCardText;
}

extension ThemeControllerExtensions on BuildContext {
  void toggleTheme() {
    if (Get.isRegistered<ThemeController>()) {
      ThemeController.to.toggleTheme();
    }
  }

  void setLightTheme() {
    if (Get.isRegistered<ThemeController>()) {
      ThemeController.to.setThemeMode(false);
    }
  }

  void setDarkTheme() {
    if (Get.isRegistered<ThemeController>()) {
      ThemeController.to.setThemeMode(true);
    }
  }

  bool get isDarkMode {
    if (Get.isRegistered<ThemeController>()) {
      return ThemeController.to.isDarkMode.value;
    }
    return false;
  }
}
