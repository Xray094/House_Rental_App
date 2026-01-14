import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:house_rental_app/core/colors/color.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find();

  final _box = GetStorage();
  final _themeKey = 'isDarkMode';
  RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = _box.read(_themeKey) ?? true;
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    _saveThemeToStorage();
    update();
  }

  void setThemeMode(bool isDark) {
    isDarkMode.value = isDark;
    _saveThemeToStorage();
    update();
  }

  void _saveThemeToStorage() {
    _box.write(_themeKey, isDarkMode.value);
  }

  ThemeMode get themeMode {
    return isDarkMode.value ? ThemeMode.dark : ThemeMode.light;
  }

  ThemeData get theme {
    return isDarkMode.value ? darkTheme : lightTheme;
  }

  ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: false,
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: LightThemeColors.scaffoldBackgroundColor,
      appBarTheme: AppBarTheme(
        backgroundColor: LightThemeColors.appBarBackground,
        foregroundColor: LightThemeColors.appBarTitleColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: LightThemeColors.appBarTitleColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: LightThemeColors.textPrimary),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: LightThemeColors.bottomNavigationBarBackground,
        selectedItemColor: LightThemeColors.bottomNavigationBarSelected,
        unselectedItemColor: LightThemeColors.bottomNavigationBarUnselected,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      cardTheme: CardThemeData(
        color: LightThemeColors.cardColor,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: LightThemeColors.buttonPrimary,
          foregroundColor: LightThemeColors.buttonPrimaryText,
          elevation: 2,
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: LightThemeColors.buttonSecondaryText,
          side: BorderSide(color: LightThemeColors.inputBorderColor),
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: LightThemeColors.primaryBlue,
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: LightThemeColors.inputFillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: LightThemeColors.inputBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: LightThemeColors.inputBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: LightThemeColors.inputFocusedBorderColor,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: LightThemeColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: LightThemeColors.error),
        ),
        hintStyle: TextStyle(color: LightThemeColors.textHint),
        labelStyle: TextStyle(color: LightThemeColors.textSecondary),
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          color: LightThemeColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: LightThemeColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: LightThemeColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(color: LightThemeColors.textPrimary),
        bodyMedium: TextStyle(color: LightThemeColors.textPrimary),
        bodySmall: TextStyle(color: LightThemeColors.textSecondary),
      ),
      dividerTheme: DividerThemeData(
        color: LightThemeColors.dividerColor,
        thickness: 1,
      ),
      colorScheme: ColorScheme.light(
        primary: LightThemeColors.primaryBlue,
        secondary: LightThemeColors.primaryBlueLight,
        surface: LightThemeColors.surfaceColor,
        background: LightThemeColors.backgroundColor,
        error: LightThemeColors.error,
        onPrimary: LightThemeColors.buttonPrimaryText,
        onSecondary: LightThemeColors.buttonPrimaryText,
        onSurface: LightThemeColors.textPrimary,
        onBackground: LightThemeColors.textPrimary,
        onError: LightThemeColors.buttonPrimaryText,
      ),
    );
  }

  ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: false,
      brightness: Brightness.dark,
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: DarkThemeColors.scaffoldBackgroundColor,
      appBarTheme: AppBarTheme(
        backgroundColor: DarkThemeColors.appBarBackground,
        foregroundColor: DarkThemeColors.appBarTitleColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: DarkThemeColors.appBarTitleColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: DarkThemeColors.textPrimary),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: DarkThemeColors.bottomNavigationBarBackground,
        selectedItemColor: DarkThemeColors.bottomNavigationBarSelected,
        unselectedItemColor: DarkThemeColors.bottomNavigationBarUnselected,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      cardTheme: CardThemeData(
        color: DarkThemeColors.cardColor,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: DarkThemeColors.buttonPrimary,
          foregroundColor: DarkThemeColors.buttonPrimaryText,
          elevation: 2,
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: DarkThemeColors.buttonSecondaryText,
          side: BorderSide(color: DarkThemeColors.inputBorderColor),
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: DarkThemeColors.primaryBlue,
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: DarkThemeColors.inputFillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: DarkThemeColors.inputBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: DarkThemeColors.inputBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: DarkThemeColors.inputFocusedBorderColor,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: DarkThemeColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: DarkThemeColors.error),
        ),
        hintStyle: TextStyle(color: DarkThemeColors.textHint),
        labelStyle: TextStyle(color: DarkThemeColors.textSecondary),
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          color: DarkThemeColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: DarkThemeColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: DarkThemeColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(color: DarkThemeColors.textPrimary),
        bodyMedium: TextStyle(color: DarkThemeColors.textPrimary),
        bodySmall: TextStyle(color: DarkThemeColors.textSecondary),
      ),
      dividerTheme: DividerThemeData(
        color: DarkThemeColors.dividerColor,
        thickness: 1,
      ),
      colorScheme: ColorScheme.dark(
        primary: DarkThemeColors.primaryBlue,
        secondary: DarkThemeColors.primaryBlueLight,
        surface: DarkThemeColors.surfaceColor,
        background: DarkThemeColors.backgroundColor,
        error: DarkThemeColors.error,
        onPrimary: DarkThemeColors.buttonPrimaryText,
        onSecondary: DarkThemeColors.buttonPrimaryText,
        onSurface: DarkThemeColors.textPrimary,
        onBackground: DarkThemeColors.textPrimary,
        onError: DarkThemeColors.buttonPrimaryText,
      ),
    );
  }
}
