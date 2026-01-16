import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:merlin_client/merlin_client.dart';

class CalendarDayView extends StatelessWidget {
  const CalendarDayView({
    super.key,
    required this.date,
    required this.events,
    this.onEventTap,
    this.calendarColors,
  });

  final DateTime date;
  final List<CalendarEvent> events;
  final void Function(CalendarEvent event)? onEventTap;
  final Map<String, Color>? calendarColors;

  @override
  Widget build(BuildContext context) {
    final dayStart = DateTime(date.year, date.month, date.day);
    final now = DateTime.now();
    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;

    // Sort events by start time
    final dayEvents =
        events
            .where(
              (e) =>
                  e.startTime.isBefore(dayStart.add(const Duration(days: 1))) &&
                  e.endTime.isAfter(dayStart),
            )
            .toList()
          ..sort((a, b) => a.startTime.compareTo(b.startTime));

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 100),
      itemCount: 24,
      itemBuilder: (context, index) {
        final hourStart = dayStart.add(Duration(hours: index));
        final hourEnd = hourStart.add(const Duration(hours: 1));

        // Get events that overlap with this hour
        final hourEvents = dayEvents.where(
          (event) =>
              event.startTime.isBefore(hourEnd) &&
              event.endTime.isAfter(hourStart),
        );

        // Check if current time is in this hour
        final showCurrentTime =
            isToday &&
            now.hour == index &&
            now.isAfter(hourStart) &&
            now.isBefore(hourEnd);

        return _HourRow(
          hour: index,
          hourStart: hourStart,
          events: hourEvents.toList(),
          onEventTap: onEventTap,
          calendarColors: calendarColors,
          showCurrentTimeLine: showCurrentTime,
          currentTimeOffset: showCurrentTime ? (now.minute / 60.0) : null,
        );
      },
    );
  }
}

class _HourRow extends StatelessWidget {
  const _HourRow({
    required this.hour,
    required this.hourStart,
    required this.events,
    this.onEventTap,
    this.calendarColors,
    this.showCurrentTimeLine = false,
    this.currentTimeOffset,
  });

  final int hour;
  final DateTime hourStart;
  final List<CalendarEvent> events;
  final void Function(CalendarEvent event)? onEventTap;
  final Map<String, Color>? calendarColors;
  final bool showCurrentTimeLine;
  final double? currentTimeOffset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeFormat = DateFormat('h a');
    final rowHeight = 80.0;

    return SizedBox(
      height: rowHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time label
          SizedBox(
            width: 56,
            child: Padding(
              padding: const EdgeInsets.only(top: 0, right: 8),
              child: Text(
                timeFormat.format(hourStart),
                textAlign: TextAlign.right,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.4),
                  fontSize: 12,
                ),
              ),
            ),
          ),

          // Content area with line and events
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: theme.colorScheme.outline.withOpacity(0.3),
                        width: 0.5,
                      ),
                      bottom: BorderSide(
                        color: theme.colorScheme.outline.withOpacity(0.15),
                        width: 0.5,
                      ),
                    ),
                  ),
                ),

                if (showCurrentTimeLine && currentTimeOffset != null)
                  Positioned(
                    top: currentTimeOffset! * rowHeight,
                    left: 0,
                    right: 0,
                    child: Row(
                      children: [
                        // Blue dot
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        // Blue line
                        Expanded(
                          child: Container(
                            height: 2,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Events
                if (events.isNotEmpty)
                  Positioned(
                    top: 4,
                    left: 8,
                    right: 8,
                    bottom: 4,
                    child: _buildEventLayout(
                      context,
                      events.toList(),
                      calendarColors,
                      onEventTap,
                      theme,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildEventLayout(
    BuildContext context,
    List<CalendarEvent> events,
    Map<String, Color>? calendarColors,
    void Function(CalendarEvent)? onEventTap,
    ThemeData theme,
  ) {
    if (events.isEmpty) return const SizedBox.shrink();
    if (events.length == 1) {
      return _EventCard(
        event: events[0],
        color:
            calendarColors?[events[0].calendarId] ?? theme.colorScheme.primary,
        onTap: onEventTap != null ? () => onEventTap(events[0]) : null,
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: events.map((event) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 4),
            child: _EventCard(
              event: event,
              color:
                  calendarColors?[event.calendarId] ??
                  theme.colorScheme.primary,
              onTap: onEventTap != null ? () => onEventTap(event) : null,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({
    required this.event,
    required this.color,
    this.onTap,
  });

  final CalendarEvent event;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeFormat = DateFormat('h:mm a');
    final startTime = timeFormat.format(event.startTime.toLocal());
    final endTime = timeFormat.format(event.endTime.toLocal());

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
            border: Border(
              left: BorderSide(
                color: color,
                width: 3,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(
                event.title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              // Time
              Text(
                '$startTime - $endTime',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 11,
                ),
              ),
              // Location (if available)
              if (event.location != null && event.location!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Row(
                    children: [
                      Icon(
                        Icons.place_outlined,
                        size: 12,
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.location!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
