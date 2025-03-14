import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

var brightness =
    SchedulerBinding.instance.platformDispatcher.platformBrightness;

final class AppTheme {
  static ThemeData defaultTheme = ThemeData(
    useMaterial3: true,
    canvasColor: Colors.white,
     scaffoldBackgroundColor: Colors.white,
    primarySwatch: const MaterialColor(0xFF003CFF, {
      50: Color(0xFFE5EBFF),
      100: Color(0xFFBFD0FF),
      200: Color(0xFF99B5FF),
      300: Color(0xFF739AFF),
      400: Color(0xFF4D7FFF),
      500: Color(0xFF2664FF),
      600: Color(0xFF0049FF),
      700: Color(0xFF0049FF),
      800: Color(0xFF0029B4),
      900: Color(0xFF001C80),
    }),
    // colorScheme: brightness == Brightness.light ? lightTheme : darkTheme,
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF0049FF),
      onPrimary: Colors.white,
      secondary: Color(0xFF4A4754),
      onSecondary: Colors.white,
      tertiary: Color(0xFF111827),
      onTertiary: Colors.white,
      surface: Colors.white,
    ),
    textTheme: customTextTheme(),
    iconButtonTheme: _getIconButtonTheme(),
    popupMenuTheme: _getPopupMenuTheme(),
    sliderTheme: _getSliderTheme(),
    switchTheme: _getSwitchTheme(),
    checkboxTheme: _getCheckboxTheme(),
    inputDecorationTheme: _getInputDecorationTheme(),
    dialogTheme: _getDialogTheme(),
    dropdownMenuTheme: _dropdownMenuThemeData(),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFF0049FF),
      unselectedItemColor: const Color(0xFFA19EAD),
      elevation: 5,
      selectedIconTheme: IconThemeData(size: 30.h),
      unselectedIconTheme: IconThemeData(size: 28.h),
    ),
    scrollbarTheme: ScrollbarThemeData(
      thickness: WidgetStateProperty.all(2.w),
      radius: Radius.circular(4.r),
    ),
    elevatedButtonTheme: _getElevatedButtonTheme(),
  );
}

ColorScheme darkTheme = const ColorScheme(
  primary: Color(0xFF0049FF),
  secondary: Color(0xFF4A4754),
  surface: Color(0xFF111827),
  error: Color(0xFFD32F2F),
  onPrimary: Colors.white,
  onSecondary: Colors.white,
  onSurface: Colors.white,
  onError: Colors.white,
  brightness: Brightness.dark,
);

ColorScheme lightTheme = const ColorScheme(
  primary: Color(0xFF0049FF),
  secondary: Color(0xFF4A4754),
  surface: Color(0xFFE5E5E5),
  error: Color(0xFFD32F2F),
  onPrimary: Colors.white,
  onSecondary: Colors.white,
  onSurface: Color(0xFF111827),
  onError: Colors.white,
  brightness: Brightness.light,
);

TextTheme customTextTheme() {
  return TextTheme(
    bodyLarge: TextStyle(
        fontFamily: 'Poppins', fontSize: 16.sp, fontWeight: FontWeight.w400),
    bodyMedium: TextStyle(
        fontFamily: 'Poppins', fontSize: 14.sp, fontWeight: FontWeight.w400),
    bodySmall: TextStyle(
        fontFamily: 'Poppins', fontSize: 12.sp, fontWeight: FontWeight.w400),
    displayLarge: TextStyle(
        fontFamily: 'Poppins', fontSize: 20.sp, fontWeight: FontWeight.w400),
    displayMedium: TextStyle(
        fontFamily: 'Poppins', fontSize: 18.sp, fontWeight: FontWeight.w400),
    displaySmall: TextStyle(
        fontFamily: 'Poppins', fontSize: 16.sp, fontWeight: FontWeight.w400),
    headlineLarge: TextStyle(
        fontFamily: 'Poppins', fontSize: 24.sp, fontWeight: FontWeight.w600),
    headlineMedium: TextStyle(
        fontFamily: 'Poppins', fontSize: 20.sp, fontWeight: FontWeight.w600),
    headlineSmall: TextStyle(
        fontFamily: 'Poppins', fontSize: 18.sp, fontWeight: FontWeight.w600),
    labelLarge: TextStyle(
        fontFamily: 'Poppins', fontSize: 16.sp, fontWeight: FontWeight.w600),
    labelMedium: TextStyle(
        fontFamily: 'Poppins', fontSize: 14.sp, fontWeight: FontWeight.w600),
    labelSmall: TextStyle(
        fontFamily: 'Poppins', fontSize: 12.sp, fontWeight: FontWeight.w600),
    titleLarge: TextStyle(
        fontFamily: 'Poppins', fontSize: 16.sp, fontWeight: FontWeight.w700),
    titleMedium: TextStyle(
        fontFamily: 'Poppins', fontSize: 14.sp, fontWeight: FontWeight.w700),
    titleSmall: TextStyle(
        fontFamily: 'Poppins', fontSize: 12.sp, fontWeight: FontWeight.w700),
  );
}

IconButtonThemeData _getIconButtonTheme() {
  return IconButtonThemeData(
    style: IconButton.styleFrom(
      foregroundColor: const Color(0xff0036E6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
    ),
  );
}

PopupMenuThemeData _getPopupMenuTheme() {
  return PopupMenuThemeData(
    color: Colors.white,
    position: PopupMenuPosition.under,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
  );
}

SliderThemeData _getSliderTheme() {
  return SliderThemeData(
    inactiveTrackColor: const Color(0xFFE4E3E8),
    trackHeight: 4.h,
    activeTrackColor: const Color(0xFF0049FF),
    thumbColor: Colors.white,
    overlayShape: RoundSliderOverlayShape(overlayRadius: 32.r),
    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.r, elevation: 5),
    showValueIndicator: ShowValueIndicator.never,
  );
}

SwitchThemeData _getSwitchTheme() {
  return SwitchThemeData(
    trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
    trackOutlineWidth: const WidgetStatePropertyAll(0),
    thumbColor: const WidgetStatePropertyAll(Colors.white),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return const Color(0xFF0049FF);
      }
      return const Color(0xFFA19EAD);
    }),
  );
}

CheckboxThemeData _getCheckboxTheme() {
  return CheckboxThemeData(
    side: BorderSide(color: const Color(0xFFD1D5DB), width: .5.w),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
    fillColor: WidgetStateProperty.resolveWith((states) {
      //value true => Color(0xFF0049FF)
      //value false => Color(0xFFA19EAD)
      if (states.contains(WidgetState.selected)) {
        return const Color(0xFF0049FF);
      }
      if (states.contains(WidgetState.disabled)) {
        return const Color(0xFFE4E3E8);
      }
      return const Color(0xFFA19EAD);
    }),
  );
}

InputDecorationTheme _getInputDecorationTheme() {
  return InputDecorationTheme(
    border: OutlineInputBorder(
      // borderRadius: BorderRadius.circular(8),
      borderRadius: BorderRadius.circular(4.r),
      borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
    ),
    enabledBorder: OutlineInputBorder(
      // borderRadius: BorderRadius.circular(8),
      borderRadius: BorderRadius.circular(4.r),
      borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
    ),
    focusedBorder: OutlineInputBorder(
      // borderRadius: BorderRadius.circular(8),
      borderRadius: BorderRadius.circular(4.r),
      borderSide: const BorderSide(color: Color(0xFF0049FF)),
    ),
    errorBorder: OutlineInputBorder(
      // borderRadius: BorderRadius.circular(8),
      borderRadius: BorderRadius.circular(4.r),
      borderSide: const BorderSide(color: Colors.red),
    ),
    focusedErrorBorder: OutlineInputBorder(
      // borderRadius: BorderRadius.circular(8),
      borderRadius: BorderRadius.circular(4.r),
      borderSide: const BorderSide(color: Color(0xFF0049FF)),
    ),
    errorStyle: const TextStyle(color: Colors.red),
    hintStyle:
        const TextStyle(color: Color(0xFFA19EAD), fontWeight: FontWeight.w400),
    labelStyle: const TextStyle(color: Color(0xFF111827), fontSize: 14),
    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
    constraints: const BoxConstraints(minHeight: 36),
  );
}

DialogTheme _getDialogTheme() {
  return DialogTheme(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    surfaceTintColor: Colors.white,
    backgroundColor: Colors.white,
  );
}

DropdownMenuThemeData _dropdownMenuThemeData() {
  return DropdownMenuThemeData(
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        // borderRadius: BorderRadius.circular(12),
        borderRadius: BorderRadius.circular(4.r),
        borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
      ),
      enabledBorder: OutlineInputBorder(
        // borderRadius: BorderRadius.circular(12),
        borderRadius: BorderRadius.circular(4.r),
        borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
      ),
      focusedBorder: OutlineInputBorder(
        // borderRadius: BorderRadius.circular(12),
        borderRadius: BorderRadius.circular(4.r),
        borderSide: const BorderSide(color: Color(0xFF0049FF)),
      ),
      errorBorder: OutlineInputBorder(
        // borderRadius: BorderRadius.circular(12),
        borderRadius: BorderRadius.circular(4.r),
        borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        // borderRadius: BorderRadius.circular(12),
        borderRadius: BorderRadius.circular(4.r),
        borderSide: const BorderSide(color: Color(0xFF0049FF)),
      ),
      errorStyle: const TextStyle(color: Color(0xFFD1D5DB)),
      hintStyle: const TextStyle(color: Color(0xFFA19EAD)),
      labelStyle: TextStyle(color: const Color(0xFF111827), fontSize: 16.sp),
    ),
    textStyle: TextStyle(color: const Color(0xFF111827), fontSize: 16.sp),
  );
}

ElevatedButtonThemeData _getElevatedButtonTheme() {
  return ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: const Color(0xFF0049FF),
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 0,
      minimumSize: Size(220.w, 56.h),
    ),
  );
}
