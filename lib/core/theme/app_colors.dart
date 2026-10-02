import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Core Palette from Design System
  static const Color primaryBlue = Color(0xFF0056D7);    //
  static const Color secondaryTeal = Color(0xFF14B8A6);  //[cite: 1]
  static const Color accentOrange = Color(0xFFF97316);   //[cite: 1]
  static const Color successGreen = Color(0xFF10B981);   //[cite: 1]
  static const Color errorRed = Color(0xFFEF4444);       //[cite: 1]

  // Backgrounds & Neutral Surfaces
  static const Color background = Color(0xFFF8FAFC);     //[cite: 1]
  static const Color surface = Colors.white;
  static const Color cardBorder = Color(0xFFE2E8F0);

  // Typography Colors
  static const Color textPrimary = Color(0xFF0F172A);    //[cite: 1]
  static const Color textSecondary = Color(0xFF64748B);  //[cite: 1]
  static const Color textLight = Colors.white;

  // Status Colors
  static const Color activeGreen = Color(0xFF10B981);    //[cite: 1]
  static const Color pendingYellow = Color(0xFFF59E0B);
  static const Color dangerRed = Color(0xFFEF4444);      //[cite: 1]
}