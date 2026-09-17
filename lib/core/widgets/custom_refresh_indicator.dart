import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CustomRefreshIndicator extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;

  const CustomRefreshIndicator({
    super.key,
    required this.onRefresh,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColors.primaryBlueStart,
      backgroundColor: AppColors.bgWhite,
      child: child,
    );
  }
}
