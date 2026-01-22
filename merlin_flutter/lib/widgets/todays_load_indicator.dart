import 'package:flutter/material.dart';

enum DayLoad { light, moderate, heavy }

class TodaysLoadIndicator extends StatelessWidget {
  final int eventCount;
  final double totalHoursBooked;

  const TodaysLoadIndicator({
    super.key,
    required this.eventCount,
    this.totalHoursBooked = 0,
  });

  DayLoad get _load {
    if (eventCount == 0) return DayLoad.light;
    if (eventCount <= 3 && totalHoursBooked <= 4) return DayLoad.light;
    if (eventCount <= 6 && totalHoursBooked <= 6) return DayLoad.moderate;
    return DayLoad.heavy;
  }

  String get _label {
    switch (_load) {
      case DayLoad.light:
        return 'Light';
      case DayLoad.moderate:
        return 'Moderate';
      case DayLoad.heavy:
        return 'Heavy';
    }
  }

  Color _getColor(BuildContext context) {
    switch (_load) {
      case DayLoad.light:
        return const Color(0xFF7EE8A8);
      case DayLoad.moderate:
        return const Color(0xFFE8C87E);
      case DayLoad.heavy:
        return const Color(0xFFE87E8A);
    }
  }

  IconData get _icon {
    switch (_load) {
      case DayLoad.light:
        return Icons.sunny;
      case DayLoad.moderate:
        return Icons.wb_cloudy_outlined;
      case DayLoad.heavy:
        return Icons.bolt;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getColor(context);

    return Tooltip(
      message: _getTooltipMessage(),
      preferBelow: true,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.3),
        ),
      ),
      textStyle: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.onSurface,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _icon,
              size: 14,
              color: color,
            ),
            const SizedBox(width: 6),
            Text(
              _label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTooltipMessage() {
    switch (_load) {
      case DayLoad.light:
        return 'Light day — room for deep work';
      case DayLoad.moderate:
        return 'Balanced schedule — plan breaks';
      case DayLoad.heavy:
        return 'Heavy load — protect your focus time';
    }
  }
}
