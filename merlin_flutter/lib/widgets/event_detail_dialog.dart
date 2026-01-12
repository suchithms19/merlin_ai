import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:merlin_client/merlin_client.dart';

class EventDetailDialog extends StatelessWidget {
  const EventDetailDialog({
    super.key,
    required this.event,
    this.calendar,
  });

  final CalendarEvent event;
  final Calendar? calendar;

  static Future<void> show(
    BuildContext context, {
    required CalendarEvent event,
    Calendar? calendar,
  }) {
    return showDialog(
      context: context,
      builder: (_) => EventDetailDialog(
        event: event,
        calendar: calendar,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('EEE, MMM d • h:mm a');
    final timeRange =
        '${formatter.format(event.startTime.toLocal())} - ${formatter.format(event.endTime.toLocal())}';

    return AlertDialog(
      title: Text(event.title),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (calendar != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  calendar!.name,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
                ),
              ),
            _InfoRow(
              icon: Icons.schedule,
              label: timeRange,
            ),
            if (event.location != null && event.location!.isNotEmpty)
              _InfoRow(
                icon: Icons.place_outlined,
                label: event.location!,
              ),
            if (event.description != null && event.description!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Text(
                  event.description!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            if (event.attendees.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Attendees',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ...event.attendees.map(
                      (email) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Text(email),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
