import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../providers/announcement_provider.dart';
import '../widgets/announcement_card.dart';

class AnnouncementScreen extends ConsumerWidget {
  const AnnouncementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcements = ref.watch(announcementProvider);

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: const CustomAppBar(
        title: AppStrings.announcement,
      ),
      body: announcements.isEmpty
          ? const Center(
              child: Text(AppStrings.noAnnouncement),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: announcements.length,
              itemBuilder: (context, index) {
                final item = announcements[index];
                return AnnouncementCard(
                  title: item.title,
                  description: item.description,
                  date: item.date,
                  onTap: () => context.push('/announcement/detail', extra: item),
                );
              },
            ),
    );
  }
}
