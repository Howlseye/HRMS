import 'package:flutter/material.dart';

class AppTextStyles {
  AppTextStyles._();

  static const String fontFamilyPrimary = 'Inter';
  static const String fontFamilySecondary = 'Nunito';

  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamilySecondary,
    fontSize: 30,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontFamilySecondary,
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle displayMediumHeavy = TextStyle(
    fontFamily: fontFamilySecondary,
    fontSize: 24,
    fontWeight: FontWeight.w900,
  );

  static const TextStyle heading = TextStyle(
    fontFamily: fontFamilySecondary,
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle headingBold = TextStyle(
    fontFamily: fontFamilySecondary,
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle headingExtraBold = TextStyle(
    fontFamily: fontFamilySecondary,
    fontSize: 20,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle headingSmall = TextStyle(
    fontFamily: fontFamilySecondary,
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle title = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodyMediumMedium = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle bodyMediumSemiBold = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle bodyMediumExtraBold = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodySmallBold = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: 12,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle label = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: 10,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: 10,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle buttonText = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
}
