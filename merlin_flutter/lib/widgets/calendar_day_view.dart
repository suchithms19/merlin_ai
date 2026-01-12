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
      itemCount: 24,
      itemBuilder: (context, index) {
        final hourStart = dayStart.add(Duration(hours: index));
        final hourEnd = hourStart.add(const Duration(hours: 1));

        final hourEvents = dayEvents.where(
          (event) =>
              event.startTime.isBefore(hourEnd) &&
              event.endTime.isAfter(hourStart),
        );

        return SizedBox(
          height: 72,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 60,
                child: Text(
                  DateFormat('h a').format(hourStart),
                  textAlign: TextAlign.right,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(
                      height: 1,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 6),
                    ...hourEvents.map((event) {
                      final calendarColor =
                          calendarColors?[event.calendarId] ?? Colors.blue[200];
                      final start = DateFormat(
                        'h:mm a',
                      ).format(event.startTime.toLocal());
                      final end = DateFormat(
                        'h:mm a',
                      ).format(event.endTime.toLocal());

                      return GestureDetector(
                        onTap: onEventTap != null
                            ? () => onEventTap!(event)
                            : null,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color:
                                calendarColor?.withOpacity(0.3) ??
                                Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: calendarColor ?? Colors.blue,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.title,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '$start - $end',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: Colors.grey[700]),
                              ),
                              if (event.location != null &&
                                  event.location!.isNotEmpty)
                                Text(
                                  event.location!,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: Colors.grey[600]),
                                ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
