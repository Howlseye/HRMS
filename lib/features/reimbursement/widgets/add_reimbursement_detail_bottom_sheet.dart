import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/widgets/custom_dropdown_field.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/custom_date_picker_field.dart';
import '../../../core/widgets/app_popup.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/utils/currency_input_formatter.dart';
import 'package:intl/intl.dart';
import '../models/reimbursement_model.dart';
import '../providers/reimbursement_provider.dart';

import '../providers/draft_detail_provider.dart';

class AddReimbursementDetailBottomSheet extends ConsumerStatefulWidget {
  final ReimbursementItemModel? initialItem;
  final VoidCallback? onDelete;

  const AddReimbursementDetailBottomSheet({
    super.key,
    this.initialItem,
    this.onDelete,
  });

  @override
  ConsumerState<AddReimbursementDetailBottomSheet> createState() => _AddReimbursementDetailBottomSheetState();
}

class _AddReimbursementDetailBottomSheetState extends ConsumerState<AddReimbursementDetailBottomSheet> {
  String? _selectedBenefit;
  DateTime? _transactionDate;
  File? _attachment;
  bool _isFormValid = false;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();  String? _existingAttachmentName;

  @override
  void initState() {
    super.initState();
    if (widget.initialItem != null) {
      _selectedBenefit = widget.initialItem!.name;
      _transactionDate = DateFormat('d MMM yyyy').parse(widget.initialItem!.transactionDate);
      _amountController.text = widget.initialItem!.amount.replaceAll(RegExp(r'[^0-9]'), '');
      _descriptionController.text = widget.initialItem!.description;
      _existingAttachmentName = widget.initialItem!.attachmentName;
    } else {
      final draft = ref.read(draftDetailProvider);
      _selectedBenefit = draft.selectedBenefit;
      _transactionDate = draft.transactionDate;
      _attachment = draft.attachment;
      _existingAttachmentName = draft.existingAttachmentName;
      _amountController.text = draft.amount;
      _descriptionController.text = draft.description;
    }
    _amountController.addListener(_updateSaveButtonState);
    _descriptionController.addListener(_updateSaveButtonState);
    

    _updateSaveButtonState();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _updateSaveButtonState() {
    setState(() {
      _isFormValid = _selectedBenefit != null &&
          _transactionDate != null &&
          _amountController.text.isNotEmpty &&
          _descriptionController.text.isNotEmpty &&
          (_attachment != null || _existingAttachmentName != null);
    });

    if (widget.initialItem == null) {
      final draft = ref.read(draftDetailProvider);
      draft.selectedBenefit = _selectedBenefit;
      draft.transactionDate = _transactionDate;
      draft.attachment = _attachment;
      draft.existingAttachmentName = _existingAttachmentName;
      draft.amount = _amountController.text;
      draft.description = _descriptionController.text;
    }
  }

  Future<void> _showAttachmentSourceDialog() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.only(bottom: 24),
          decoration: const BoxDecoration(
            color: AppColors.bgWhite,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                Container(
                  width: 32,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.iconGray,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  AppStrings.chooseAttachmentSource,
                  style: AppTextStyles.titleBold.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.filterChipBgActive,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.camera_alt, color: AppColors.primaryBlueStart),
                  ),
                  title: Text(
                    AppStrings.takePhoto, 
                    style: AppTextStyles.bodyMediumBold.copyWith(color: AppColors.textPrimary),
                  ),
                  subtitle: Text(
                    AppStrings.useCameraDirectly, 
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickAttachment(ImageSource.camera);
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Divider(color: AppColors.borderLight, height: 1),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.filterChipBgActive,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.folder, color: AppColors.primaryBlueStart),
                  ),
                  title: Text(
                    AppStrings.chooseFromGallery, 
                    style: AppTextStyles.bodyMediumBold.copyWith(color: AppColors.textPrimary),
                  ),
                  subtitle: Text(
                    AppStrings.choosePhotoOrPdf, 
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickAttachment(null);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickAttachment(ImageSource? source) async {
    File? pickedFile;

    if (source != null) {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);
      if (image != null) {
        pickedFile = File(image.path);
      }
    } else {
      PlatformFile? result = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'pdf'],
      );

      if (result != null && result.path != null) {
        pickedFile = File(result.path!);
      }
    }

    if (pickedFile != null) {
      final int fileSize = await pickedFile.length();
      if (fileSize > 5 * 1024 * 1024) {
        if (mounted) {
          AppSnackbar.show(
            context,
            message: AppStrings.maxFileSize,
            type: SnackbarType.error,
          );
        }
        return;
      }

      setState(() {
        _attachment = pickedFile;
        _existingAttachmentName = null;
      });
      _updateSaveButtonState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          Flexible(
            child: ref.watch(benefitTypeProvider).when(
              data: (benefits) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildFormFields(benefits),
                    ],
                  ),
                );
              },
              loading: () => const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, stack) => Padding(
                padding: const EdgeInsets.all(48.0),
                child: Center(
                  child: Text(
                    '${AppStrings.errorLoadBenefitType}$err',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          _buildSaveButton(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          width: 32,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.dragHandle,
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          widget.initialItem != null ? AppStrings.editDetail : AppStrings.addBenefitDetailTitle,
          style: AppTextStyles.titleBold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildFormFields(List<String> benefits) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomDropdownField(
          label: AppStrings.benefitType,
          value: _selectedBenefit,
          items: benefits,
          hintText: AppStrings.selectBenefitType,
          isRequired: true,
          onChanged: (value) {
            setState(() {
              _selectedBenefit = value;
            });
            _updateSaveButtonState();
          },
        ),
        const SizedBox(height: 16),
        CustomDatePickerField(
          label: AppStrings.transactionDate,
          hintText: AppStrings.selectTransactionDate,
          isRequired: true,
          value: _transactionDate,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
          onChanged: (date) {
            setState(() {
              _transactionDate = date;
            });
            _updateSaveButtonState();
          },
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: AppStrings.submittedAmount,
          hintText: AppStrings.zeroText,
          isRequired: true,
          keyboardType: TextInputType.number,
          inputFormatters: [CurrencyInputFormatter()],
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 8.0),
            child: Text(
              AppStrings.rpText,
              style: AppTextStyles.bodyMediumMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          controller: _amountController,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: AppStrings.deskripsi,
          hintText: AppStrings.descPlaceholder,
          isRequired: true,
          maxLines: 3,
          minLines: 3,
          controller: _descriptionController,
        ),
        const SizedBox(height: 16),
        _buildFileUpload(),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildFileUpload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: AppStrings.attachment,
            style: AppTextStyles.bodyMediumMedium.copyWith(color: AppColors.textPrimary),
            children: [
              TextSpan(
                text: '*',
                style: AppTextStyles.bodyMediumMedium.copyWith(color: AppColors.textDanger),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        _attachment != null || _existingAttachmentName != null
            ? Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.filterChipBgActive,
                  border: Border.all(color: AppColors.primaryBlueStart),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.description, color: AppColors.primaryBlueStart, size: 24),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _attachment != null
                          ? Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    _attachment!.path.split(Platform.pathSeparator).last,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.textPrimary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  ' - ${(_attachment!.lengthSync() / (1024 * 1024)).toStringAsFixed(1)} mb',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              _existingAttachmentName!,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _attachment = null;
                          _existingAttachmentName = null;
                        });
                        _updateSaveButtonState();
                      },
                      child: const Icon(
                        Icons.close,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              )
            : CustomPaint(
                painter: DashedBorderPainter(color: AppColors.borderLight),
                child: InkWell(
                  onTap: _showAttachmentSourceDialog,
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.file_upload_outlined,
                          color: AppColors.primaryBlueStart,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: AppStrings.dragFileHere,
                                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                              ),
                              TextSpan(
                                text: AppStrings.chooseFromDevice,
                                style: AppTextStyles.bodyMediumBold.copyWith(color: AppColors.primaryBlueStart),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        const SizedBox(height: 8),
        Text(
          AppStrings.maxFileSize,
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
        ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.bgWhite,
          border: Border(
            top: BorderSide(
              color: AppColors.borderDivider,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            if (widget.initialItem != null) ...[
              Expanded(
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AppPopup(
                        svgAsset: AppAssets.popupCancelIcon,
                        title: AppStrings.deleteDetailConfirmTitle,
                        description: AppStrings.deleteDetailConfirmDesc,
                        secondaryButtonText: AppStrings.batal,
                        primaryButtonText: AppStrings.confirmDelete,
                        primaryButtonColor: AppColors.textDanger,
                        onPrimaryPressed: () {
                          Navigator.pop(context);
                          if (widget.onDelete != null) widget.onDelete!();
                          Navigator.pop(context);
                        },
                        onSecondaryPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                  child: Container(
                    height: 48,
                    alignment: Alignment.center,
                    child: Text(
                      AppStrings.deleteDetail,
                      style: AppTextStyles.bodyMediumBold.copyWith(color: AppColors.textDanger),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],
            Expanded(
              child: InkWell(
                onTap: _isFormValid ? () {
                  final item = ReimbursementItemModel(
                    name: _selectedBenefit!,
                    amount: _amountController.text.startsWith('Rp') 
                        ? _amountController.text 
                        : 'Rp${_amountController.text}',
                    transactionDate: DateFormat('d MMM yyyy').format(_transactionDate!),
                    description: _descriptionController.text,
                    attachmentName: _attachment != null 
                        ? '${_attachment!.path.split(Platform.pathSeparator).last} - ${(_attachment!.lengthSync() / (1024 * 1024)).toStringAsFixed(1)} mb'
                        : _existingAttachmentName ?? '',
                    attachmentPath: _attachment?.path,
                  );
                  
                  if (widget.initialItem == null) {
                    ref.read(draftDetailProvider).clear();
                  }
                  
                  Navigator.pop(context, item);
                } : null,
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: _isFormValid ? AppColors.primaryBlueStart : AppColors.borderLight,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    AppStrings.save,
                    style: AppTextStyles.bodyMediumSemiBold.copyWith(
                      color: _isFormValid ? AppColors.textWhite : AppColors.textTertiary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double borderRadius;

  DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.dashWidth = 5.0,
    this.dashSpace = 5.0,
    this.borderRadius = 6.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(borderRadius),
      ));

    Path dashedPath = Path();
    for (PathMetric measurePath in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < measurePath.length) {
        dashedPath.addPath(
          measurePath.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }
    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

