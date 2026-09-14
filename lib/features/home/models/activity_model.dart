import 'package:flutter/material.dart';

class ActivityModel {
  final IconData icon;
  final String title;
  final String date;
  final String time;
  final Color? iconColor;
  final Color? iconBgColor;
  final bool isTimeWarning;

  ActivityModel({
    required this.icon,
    required this.title,
    required this.date,
    required this.time,
    this.iconColor,
    this.iconBgColor,
    this.isTimeWarning = false,
  });
}
