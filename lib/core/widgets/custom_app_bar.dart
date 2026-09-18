import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import '../theme/app_text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final Color backgroundColor;
  final Color iconColor;
  final bool centerTitle;
  final List<Widget>? actions;
  final Widget? leading;
  final TextStyle? titleStyle;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onBackPressed,
    this.backgroundColor = AppColors.transparent,
    this.iconColor = AppColors.iconGray,
    this.centerTitle = true,
    this.actions,
    this.leading,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: centerTitle,
      title: Text(
        title,
        style: titleStyle ??
            AppTextStyles.titleBold.copyWith(
              color: AppColors.textPrimary,
            ),
      ),
      leading: leading ??
          IconButton(
            icon: Icon(Icons.arrow_back, color: iconColor),
            onPressed: onBackPressed ??
                () {
                  if (context.canPop()) {
                    context.pop();
                  }
                },
          ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
