import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import '../constants/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'custom_button.dart';

class SuccessScreen extends StatelessWidget {
  final String title;
  final Widget? subtitleWidget;
  final String buttonText;
  final VoidCallback onButtonPressed;
  final VoidCallback onClosePressed;
  final String? lottieAsset;

  const SuccessScreen({
    super.key,
    required this.title,
    this.subtitleWidget,
    required this.buttonText,
    required this.onButtonPressed,
    required this.onClosePressed,
    this.lottieAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: onClosePressed,
                ),
              ),
            ),
            
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            lottieAsset != null
                                ? Lottie.asset(
                                    lottieAsset!,
                                    height: 240,
                                    width: 240,
                                    fit: BoxFit.contain,
                                    repeat: false,
                                  )
                                : SvgPicture.asset(
                                    'assets/icons/success.svg',
                                    height: 80,
                                    width: 80,
                                  ),
                            SizedBox(height: lottieAsset != null ? 0 : 24),
                      Text(
                        title,
                        style: AppTextStyles.displayMediumBold.copyWith(
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (subtitleWidget != null) ...[
                        const SizedBox(height: 16),
                        subtitleWidget!,
                      ],
                    ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              decoration: const BoxDecoration(
                color: AppColors.bgLight,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
              ),
              child: CustomButton(
                text: buttonText,
                onPressed: onButtonPressed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
