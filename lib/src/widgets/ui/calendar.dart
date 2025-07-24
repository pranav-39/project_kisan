import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  final void Function(DateTime, DateTime)? onRangeSelected;
  final DateTime? focusedDay;
  final DateTime? selectedDay;

  const Calendar({
    super.key,
    this.onRangeSelected,
    this.focusedDay,
    this.selectedDay,
  });

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.focusedDay ?? DateTime.now();
    _selectedDay = widget.selectedDay;
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime(2000),
      lastDay: DateTime(2100),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        leftChevronIcon: const Icon(Icons.chevron_left, size: 20),
        rightChevronIcon: const Icon(Icons.chevron_right, size: 20),
        headerPadding: const EdgeInsets.symmetric(vertical: 8),
        titleTextStyle: Theme.of(context).textTheme.titleMedium!,
      ),
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle,
        ),
        outsideDaysVisible: true,
        defaultTextStyle: TextStyle(
          color: Theme.of(context).textTheme.bodyMedium!.color,
          fontSize: 12,
        ),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
          fontSize: 10,
        ),
        weekendStyle: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
          fontSize: 10,
        ),
      ),
    );
  }
}
