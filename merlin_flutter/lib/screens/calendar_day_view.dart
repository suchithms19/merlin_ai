import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:merlin_client/merlin_client.dart';

import '../main.dart';
import '../widgets/calendar_day_view.dart';
import '../widgets/event_detail_dialog.dart';
import '../widgets/google_connection_widget.dart';

class CalendarDayViewScreen extends StatefulWidget {
  const CalendarDayViewScreen({super.key});

  @override
  State<CalendarDayViewScreen> createState() => _CalendarDayViewScreenState();
}

class _CalendarDayViewScreenState extends State<CalendarDayViewScreen> {
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  String? _error;
  List<Calendar> _calendars = [];
  List<CalendarEvent> _events = [];
  String? _selectedCalendarId;

  @override
  void initState() {
    super.initState();
    _loadCalendars();
  }

  Future<void> _loadCalendars() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final calendars = await client.calendar.getCalendars();
      String? selectedCalendar = _selectedCalendarId;
      if (selectedCalendar == null && calendars.isNotEmpty) {
        Calendar? primary;
        for (final cal in calendars) {
          if (cal.isPrimary) {
            primary = cal;
            break;
          }
        }
        selectedCalendar = (primary ?? calendars.first).googleCalendarId;
      }

      setState(() {
        _calendars = calendars;
        _selectedCalendarId = selectedCalendar;
        _isLoading = false;
      });

      await _loadEvents();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Failed to load calendars: $e';
      });
    }
  }

  Future<void> _loadEvents() async {
    if (_selectedCalendarId == null) {
      setState(() => _events = []);
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final dayStart = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    );
    final dayEnd = dayStart.add(const Duration(days: 1));

    try {
      final events = await client.calendar.getCalendarEvents(
        _selectedCalendarId!,
        dayStart.toUtc(),
        dayEnd.toUtc(),
      );
      setState(() {
        _events = events;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Failed to load events: $e';
      });
    }
  }

  Future<void> _sync() async {
    if (_selectedCalendarId == null) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    final dayStart = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    );
    final dayEnd = dayStart.add(const Duration(days: 1));
    try {
      await client.calendar.syncCalendar(
        calendarId: _selectedCalendarId,
        timeMin: dayStart.toUtc(),
        timeMax: dayEnd.toUtc(),
      );
      await _loadEvents();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Sync failed: $e';
      });
    }
  }

  void _changeDay(int delta) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: delta));
    });
    _loadEvents();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
      _loadEvents();
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel = DateFormat('EEEE, MMM d, y').format(_selectedDate);
    final calendarLookup = {
      for (final cal in _calendars) cal.googleCalendarId: cal,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Merlin Calendar'),
        actions: [
          IconButton(
            tooltip: 'Sync',
            onPressed: _isLoading ? null : _sync,
            icon: const Icon(Icons.sync),
          ),
        ],
      ),
      body: Row(
        children: [
          SizedBox(
            width: 320,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  GoogleConnectionWidget(client: client),
                ],
              ),
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Text(
                        dateLabel,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: _isLoading ? null : () => _changeDay(-1),
                            icon: const Icon(Icons.chevron_left),
                          ),
                          IconButton(
                            onPressed: _isLoading
                                ? null
                                : () {
                                    setState(
                                      () => _selectedDate = DateTime.now(),
                                    );
                                    _loadEvents();
                                  },
                            icon: const Icon(Icons.today),
                          ),
                          IconButton(
                            onPressed: _isLoading ? null : () => _changeDay(1),
                            icon: const Icon(Icons.chevron_right),
                          ),
                          OutlinedButton.icon(
                            onPressed: _isLoading ? null : _pickDate,
                            icon: const Icon(Icons.date_range),
                            label: const Text('Pick date'),
                          ),
                        ],
                      ),
                      if (_calendars.isNotEmpty)
                        DropdownButton<String>(
                          value: _selectedCalendarId,
                          hint: const Text('Select calendar'),
                          onChanged: (value) {
                            setState(() {
                              _selectedCalendarId = value;
                            });
                            _loadEvents();
                          },
                          items: _calendars
                              .map(
                                (c) => DropdownMenuItem<String>(
                                  value: c.googleCalendarId,
                                  child: Text(c.name),
                                ),
                              )
                              .toList(),
                        ),
                    ],
                  ),
                ),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      _error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _selectedCalendarId == null
                      ? const Center(
                          child: Text(
                            'No calendars available. Connect Google to begin.',
                          ),
                        )
                      : CalendarDayView(
                          date: _selectedDate,
                          events: _events,
                          calendarColors: {
                            for (final cal in _calendars)
                              cal.googleCalendarId: Colors.blue,
                          },
                          onEventTap: (event) => EventDetailDialog.show(
                            context,
                            event: event,
                            calendar: calendarLookup[event.calendarId],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
