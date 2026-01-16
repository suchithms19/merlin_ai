import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:merlin_client/merlin_client.dart';

import '../main.dart';
import '../theme/app_theme.dart';
import '../widgets/app_drawer.dart';
import '../widgets/calendar_day_view.dart';
import '../widgets/event_detail_dialog.dart';
import 'full_chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // Calendar state
  DateTime _selectedDate = DateTime.now();
  bool _isCalendarLoading = false;
  String? _calendarError;
  List<Calendar> _calendars = [];
  List<CalendarEvent> _events = [];
  String? _selectedCalendarId;

  // UI state
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadCalendars();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadCalendars() async {
    setState(() {
      _isCalendarLoading = true;
      _calendarError = null;
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
        _isCalendarLoading = false;
      });

      await _loadEvents();
    } catch (e) {
      setState(() {
        _isCalendarLoading = false;
        _calendarError = 'Connect your Google account to view calendar';
      });
    }
  }

  Future<void> _loadEvents() async {
    if (_selectedCalendarId == null) {
      setState(() => _events = []);
      return;
    }

    setState(() {
      _isCalendarLoading = true;
      _calendarError = null;
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
        _isCalendarLoading = false;
      });
    } catch (e) {
      setState(() {
        _isCalendarLoading = false;
        _calendarError = 'Failed to load events';
      });
    }
  }

  void _changeDay(int delta) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: delta));
    });
    _loadEvents();
  }

  void _goToToday() {
    setState(() {
      _selectedDate = DateTime.now();
    });
    _loadEvents();
  }

  void _openChatScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullChatScreen(
          onMessagesChanged: (messages) {
            if (messages.isNotEmpty) {
              final lastMsg = messages.last;
              if (lastMsg.functionsExecuted?.any((f) => 
                  f.contains('Calendar') || f.contains('Event')) ?? false) {
                _loadEvents();
              }
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = AppTheme.isMobile(context);

        if (isMobile) {
          return _buildMobileLayout(context);
        } else {
          return _buildDesktopLayout(context, constraints);
        }
      },
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const Drawer(child: AppDrawer()),
      body: SafeArea(
        child: Column(
          children: [
            _buildMobileHeader(context),
            Expanded(
              child: _buildCalendarContent(context),
            ),
            _buildMobileAIInput(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileHeader(BuildContext context) {
    final theme = Theme.of(context);
    final monthYear = DateFormat('MMMM').format(_selectedDate);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
          
          Expanded(
            child: Center(
              child: TextButton.icon(
                onPressed: () => _showMonthPicker(context),
                icon: Text(
                  monthYear,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                label: const Icon(Icons.keyboard_arrow_down, size: 20),
              ),
            ),
          ),
          _buildMiniLogo(context),
        ],
      ),
    );
  }

  Widget _buildMiniLogo(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: CustomPaint(
        painter: _MiniLogoPainter(),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, BoxConstraints constraints) {
    return Scaffold(
      body: Row(
        children: [
          const AppDrawer(),
          const VerticalDivider(width: 1),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: SafeArea(
                    child: Column(
                      children: [
                        _buildDesktopHeader(context),
                        Expanded(
                          child: _buildCalendarContent(context),
                        ),
                      ],
                    ),
                  ),
                ),
                _buildDesktopAIInput(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopHeader(BuildContext context) {
    final theme = Theme.of(context);
    final monthYear = DateFormat('MMMM yyyy').format(_selectedDate);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          child: Row(
            children: [
              TextButton.icon(
            onPressed: () => _showMonthPicker(context),
            icon: Text(
              monthYear,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            label: const Icon(Icons.keyboard_arrow_down),
          ),
          
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: _isCalendarLoading ? null : () => _changeDay(-1),
              ),
              TextButton(
                onPressed: _isCalendarLoading ? null : _goToToday,
                child: const Text('Today'),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: _isCalendarLoading ? null : () => _changeDay(1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarContent(BuildContext context) {
    final theme = Theme.of(context);
    final dayFormat = DateFormat('d');
    final dayName = DateFormat('EEE').format(_selectedDate);
    final isToday = _isToday(_selectedDate);
    final calendarLookup = {
      for (final cal in _calendars) cal.googleCalendarId: cal,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: isToday
                      ? Border.all(
                          color: theme.colorScheme.primary,
                          width: 2,
                        )
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  dayFormat.format(_selectedDate),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isToday ? theme.colorScheme.primary : null,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                dayName,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _isCalendarLoading
              ? const Center(child: CircularProgressIndicator())
              : _calendarError != null
                  ? _buildCalendarError(context)
                  : _events.isEmpty
                      ? _buildEmptyCalendar(context)
                      : CalendarDayView(
                          date: _selectedDate,
                          events: _events,
                          calendarColors: {
                            for (final cal in _calendars)
                              cal.googleCalendarId: theme.colorScheme.primary,
                          },
                          onEventTap: (event) => EventDetailDialog.show(
                            context,
                            event: event,
                            calendar: calendarLookup[event.calendarId],
                          ),
                        ),
        ),
      ],
    );
  }

  Widget _buildCalendarError(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 48,
              color: theme.colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              _calendarError!,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              icon: const Icon(Icons.link),
              label: const Text('Connect Google Account'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCalendar(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_available_outlined,
            size: 48,
            color: theme.colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No events scheduled',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ask Merlin to schedule something!',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileAIInput(BuildContext context) {
    final theme = Theme.of(context);
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return GestureDetector(
      onTap: _openChatScreen,
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + bottomPadding),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Row(
            children: [
              Icon(
                Icons.auto_awesome,
                size: 20,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Ask Merlin...',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: theme.colorScheme.onSurface.withOpacity(0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopAIInput(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: _openChatScreen,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Row(
            children: [
              Icon(
                Icons.auto_awesome,
                size: 20,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Ask Merlin...',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: theme.colorScheme.onSurface.withOpacity(0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMonthPicker(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(DateTime.now().year - 2),
      lastDate: DateTime(DateTime.now().year + 2),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
      _loadEvents();
    }
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}

/// Mini logo painter for the header
class _MiniLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.25;
    final strokeWidth = size.width * 0.08;

    const colors = [
      Color(0xFF5FD4AA),
      Color(0xFFE8B99D),
      Color(0xFFB8A5C7),
    ];

    for (int i = 0; i < 3; i++) {
      final ringCenter = Offset(
        center.dx + radius * 0.25 * (i == 0 ? -0.5 : i == 1 ? 0.5 : 0),
        center.dy + radius * 0.25 * (i == 2 ? 0.5 : -0.3),
      );

      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawCircle(ringCenter, radius, paint);
    }
  }

  @override
  bool shouldRepaint(_MiniLogoPainter oldDelegate) => false;
}
