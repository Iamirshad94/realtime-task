// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:syncfusion_flutter_calendar/calendar.dart';
// import 'package:table_calendar/table_calendar.dart';
//
// class CustomDatePicker extends StatefulWidget {
//   final Function(DateTime)? onDateSelected;
//
//   CustomDatePicker({this.onDateSelected});
//
//   @override
//   _CustomDatePickerState createState() => _CustomDatePickerState();
// }
//
// class _CustomDatePickerState extends State<CustomDatePicker> {
//   CalendarFormat _calendarFormat = CalendarFormat.month;
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;
//   final _controller = CalendarController();
//
//   @override
//   void initState() {
//     super.initState();
//     _selectedDay = DateTime.now();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildCalendar(),
//       ],
//     );
//   }
//
//   Widget _buildDatePickerButton(String label, DateTime date) {
//     bool isSelected = date.isAtSameMomentAs(_selectedDay!);
//     Color buttonColor = isSelected ? Colors.blue : Colors.grey;
//     Color textColor = isSelected ? Colors.white : Colors.black;
//
//     return ElevatedButton(
//       onPressed: () {
//         setState(() {
//           _selectedDay = date;
//         });
//       },
//       style: ButtonStyle(
//         backgroundColor: MaterialStateProperty.all<Color>(buttonColor),
//         foregroundColor: MaterialStateProperty.all<Color>(textColor),
//       ),
//       child: Text(label),
//     );
//   }
//
// }
