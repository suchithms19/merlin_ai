import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:merlin_client/merlin_client.dart';

import '../main.dart';
import '../theme/app_theme.dart';
import '../widgets/app_drawer.dart';
import '../widgets/calendar_day_view.dart';
import '../widgets/event_detail_dialog.dart';
import '../widgets/todays_load_indicator.dart';
import 'full_chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  DateTime _selectedDate = DateTime.now();
  bool _isCalendarLoading = false;
  String? _calendarError;
  List<Calendar> _calendars = [];
  List<CalendarEvent> _events = [];
  String? _selectedCalendarId;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _wasInBackground = false;
  bool _isReloading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadCalendars();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      _wasInBackground = true;
    } else if (state == AppLifecycleState.resumed && _wasInBackground) {
      _wasInBackground = false;
      if (_calendarError != null || _calendars.isEmpty) {
        _loadCalendars();
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_calendarError != null && !_isCalendarLoading && !_isReloading) {
      _isReloading = true;
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted && _calendarError != null && !_isCalendarLoading) {
          _loadCalendars();
        }
        _isReloading = false;
      });
    }
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

  void _clearCalendarData() {
    setState(() {
      _calendars.clear();
      _events.clear();
      _selectedCalendarId = null;
      _calendarError = 'Connect your Google account to view calendar';
      _isCalendarLoading = false;
    });
  }

  void _openChatScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullChatScreen(
          onMessagesChanged: (messages) {
            if (messages.isNotEmpty) {
              final lastMsg = messages.last;
              if (lastMsg.functionsExecuted?.any(
                    (f) => f.contains('Calendar') || f.contains('Event'),
                  ) ??
                  false) {
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
      drawer: Drawer(
        child: AppDrawer(
          onGoogleDisconnected: _clearCalendarData,
          onGoogleConnected: _loadCalendars,
        ),
      ),
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
    final dayNum = DateFormat('d').format(_selectedDate);
    final dayName = DateFormat('EEE').format(_selectedDate);
    final monthYear = DateFormat('MMM yyyy').format(_selectedDate);
    final isToday = _isToday(_selectedDate);

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.1),
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => _scaffoldKey.currentState?.openDrawer(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.menu_rounded,
                    size: 20,
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => _showMonthPicker(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: isToday
                              ? theme.colorScheme.primary
                              : theme.colorScheme.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          dayNum,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isToday
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dayName,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            monthYear,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 18,
                        color: theme.colorScheme.onSurface.withOpacity(0.4),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildNavButton(
                    context,
                    icon: Icons.chevron_left_rounded,
                    onTap: () => _changeDay(-1),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: _goToToday,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Today',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  _buildNavButton(
                    context,
                    icon: Icons.chevron_right_rounded,
                    onTap: () => _changeDay(1),
                  ),
                ],
              ),
            ],
          ),
          if (!_isCalendarLoading &&
              _calendarError == null &&
              _events.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  TodaysLoadIndicator(
                    eventCount: _events.length,
                    totalHoursBooked: _calculateTotalHours(),
                  ),
                  const Spacer(),
                  Text(
                    '${_events.length} event${_events.length != 1 ? 's' : ''}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNavButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: _isCalendarLoading ? null : onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 18,
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, BoxConstraints constraints) {
    return Scaffold(
      body: Row(
        children: [
          AppDrawer(
            onGoogleDisconnected: _clearCalendarData,
            onGoogleConnected: _loadCalendars,
          ),
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
    final dayNum = DateFormat('d').format(_selectedDate);
    final fullDate = DateFormat('EEEE, MMMM d, yyyy').format(_selectedDate);
    final isToday = _isToday(_selectedDate);

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isToday
                  ? theme.colorScheme.primary
                  : theme.colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Text(
              dayNum,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: isToday
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => _showMonthPicker(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        fullDate,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 20,
                        color: theme.colorScheme.onSurface.withOpacity(0.4),
                      ),
                    ],
                  ),
                ),
                if (!_isCalendarLoading && _calendarError == null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      children: [
                        TodaysLoadIndicator(
                          eventCount: _events.length,
                          totalHoursBooked: _calculateTotalHours(),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${_events.length} event${_events.length != 1 ? 's' : ''} scheduled',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildNavButton(
                context,
                icon: Icons.chevron_left_rounded,
                onTap: () => _changeDay(-1),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _goToToday,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: theme.colorScheme.primary.withOpacity(0.2),
                    ),
                  ),
                  child: Text(
                    'Today',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _buildNavButton(
                context,
                icon: Icons.chevron_right_rounded,
                onTap: () => _changeDay(1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double _calculateTotalHours() {
    double total = 0;
    for (final event in _events) {
      final duration = event.endTime.difference(event.startTime);
      total += duration.inMinutes / 60.0;
    }
    return total;
  }

  Widget _buildCalendarContent(BuildContext context) {
    final theme = Theme.of(context);
    final calendarLookup = {
      for (final cal in _calendars) cal.googleCalendarId: cal,
    };

    if (_isCalendarLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_calendarError != null) {
      return _buildCalendarError(context);
    }

    if (_events.isEmpty) {
      return _buildEmptyCalendar(context);
    }

    return CalendarDayView(
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
            'Your day is clear',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Merlin is standing by to help you plan',
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
        padding: EdgeInsets.fromLTRB(16, 10, 16, 10 + bottomPadding),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: theme.colorScheme.outline.withOpacity(0.1),
            ),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary.withOpacity(0.08),
                theme.colorScheme.secondary.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.15),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Ask Merlin anything...',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_rounded,
                size: 18,
                color: theme.colorScheme.primary.withOpacity(0.6),
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
          border: Border(
            top: BorderSide(
              color: theme.colorScheme.outline.withOpacity(0.1),
            ),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary.withOpacity(0.08),
                theme.colorScheme.secondary.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.15),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  'Ask Merlin anything...',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_rounded,
                size: 20,
                color: theme.colorScheme.primary.withOpacity(0.6),
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
