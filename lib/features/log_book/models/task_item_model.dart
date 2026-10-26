import '../../../core/constants/app_strings.dart';

class TaskItem {
  final List<String> types;
  final String summary;
  final String constraints;
  final int hours;
  final int minutes;

  TaskItem({
    required this.types,
    required this.summary,
    required this.constraints,
    required this.hours,
    required this.minutes,
  });

  String get durationString {
    final hStr = hours > 0 ? '$hours ${AppStrings.hoursLabel} ' : '';
    final mStr = minutes > 0 ? '$minutes ${AppStrings.minutesLabel}' : '';
    final result = '$hStr$mStr'.trim();
    return result.isEmpty ? '0 ${AppStrings.hoursLabel}' : result;
  }

  String get typesString => types.join(', ');
}
