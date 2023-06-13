import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:realtime_task/models/employee_model.dart';
import 'package:realtime_task/utility/constants.dart';
import 'package:realtime_task/utility/custom_appbar.dart';
import 'package:realtime_task/utility/custom_datepicker.dart';
import 'package:realtime_task/utility/custom_dropdown.dart';
import 'package:realtime_task/utility/route_constants.dart';
import '../bloc/employee_bloc.dart';
import '../bloc/employee_bloc_event.dart';
import '../bloc/employee_bloc_state.dart';
import '../utility/custom_button.dart';
import '../utility/custom_textfield.dart';

class EditEmployeeDetails extends StatefulWidget {
  final Employee employee;
  EditEmployeeDetails({super.key, required this.employee});

  @override
  State<EditEmployeeDetails> createState() => _EditEmployeeDetailsState();
}

class _EditEmployeeDetailsState extends State<EditEmployeeDetails> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();

  late EmployeeBloc _employeeBloc;
  String? dropDownValue;
  String? _selectedDate;
  String? _selectedDateTo;
  DateTime? _focusedDay;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.employee.name;
    _employeeBloc = BlocProvider.of<EmployeeBloc>(context);
    DateTime fromDate = DateTime.parse(widget.employee.fromDate);

    DateTime endDate = DateTime.parse(widget.employee.endDate);
    _roleController.text = widget.employee.profession;
    _employeeBloc.add(EmployeeFormUpdate(
        employeeRole: _roleController.text,
        selectedDate: fromDate,
        selectedDateTo: endDate));
  }

  // function for selecting today's date
  void _selectToday(bool isStartDate) {
    if (!isStartDate) {
      _employeeBloc.add(EmployeeFormUpdate(
          employeeRole: _roleController.text.isEmpty
              ? AppConstants.menuItems[0]
              : _roleController.text,
          selectedDate: DateTime.parse(_selectedDate!),
          selectedDateTo: DateTime.now()));
    } else {
      _employeeBloc.add(EmployeeFormUpdate(
          employeeRole: _roleController.text.isEmpty
              ? AppConstants.menuItems[0]
              : _roleController.text,
          selectedDateTo: DateTime.parse(_selectedDateTo!),
          selectedDate: DateTime.now()));
    }
  }

  // function for selecting next monday from today's date
  void _selectNextMonday(bool isStartDate) {
    if (!isStartDate) {
      _employeeBloc.add(EmployeeFormUpdate(
          employeeRole: _roleController.text.isEmpty
              ? AppConstants.menuItems[0]
              : _roleController.text,
          selectedDate: DateTime.parse(_selectedDate!),
          selectedDateTo: _getNextWeekday(DateTime.monday)));
    } else {
      _employeeBloc.add(EmployeeFormUpdate(
          employeeRole: _roleController.text.isEmpty
              ? AppConstants.menuItems[0]
              : _roleController.text,
          selectedDateTo: DateTime.parse(_selectedDateTo!),
          selectedDate: _getNextWeekday(DateTime.monday)));
    }
  }

  // function for selecting next tuesday from today's date
  void _selectNextTuesday(bool isStartDate) {
    if (!isStartDate) {
      _employeeBloc.add(EmployeeFormUpdate(
          employeeRole: _roleController.text.isEmpty
              ? AppConstants.menuItems[0]
              : _roleController.text,
          selectedDate: DateTime.parse(_selectedDate!),
          selectedDateTo: _getNextWeekday(DateTime.tuesday)));
    } else {
      _employeeBloc.add(EmployeeFormUpdate(
          employeeRole: _roleController.text.isEmpty
              ? AppConstants.menuItems[0]
              : _roleController.text,
          selectedDateTo: DateTime.parse(_selectedDateTo!),
          selectedDate: _getNextWeekday(DateTime.tuesday)));
    }
  }

  // function for selecting next week date from today's date
  void _selectNextWeek(bool isStartDate) {
    if (!isStartDate) {
      _employeeBloc.add(EmployeeFormUpdate(
          employeeRole: _roleController.text.isEmpty
              ? AppConstants.menuItems[0]
              : _roleController.text,
          selectedDate: DateTime.parse(_selectedDate!),
          selectedDateTo: DateTime.now().add(const Duration(days: 7))));
    } else {
      _employeeBloc.add(EmployeeFormUpdate(
          employeeRole: _roleController.text.isEmpty
              ? AppConstants.menuItems[0]
              : _roleController.text,
          selectedDateTo: DateTime.parse(_selectedDateTo!),
          selectedDate: DateTime.now().add(const Duration(days: 7))));
    }
  }

  // function for adding 7 days into current day
  DateTime _getNextWeekday(int weekday) {
    final now = DateTime.now();
    if (weekday == now.weekday) {
      int daysUntilNextWeekday = ((weekday - now.weekday + 7) % 7);
      return now.add(Duration(days: daysUntilNextWeekday + 7));
    } else {
      int daysUntilNextWeekday = ((weekday - now.weekday + 7) % 7);
      return now.add(Duration(days: daysUntilNextWeekday));
    }
  }

  // this function is use to format date into this March 1, 2023 formate
  String formatDate(DateTime? dateTime) {
    if (dateTime != null) {
      return DateFormat.yMMMMd().format(dateTime);
    }
    return 'No Date';
    // will give output as March 1, 2023
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return BlocBuilder<EmployeeBloc, EmployeeState>(builder: (context, state) {
      if (state is! EmployeeFromState) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else {
        // adding initial date and profession values
        _selectedDate = state.selectedDate == null
            ? 'No Date'
            : state.selectedDate.toString();
        _selectedDateTo = state.selectedDateTo == null
            ? 'No Date'
            : state.selectedDateTo.toString();
        debugPrint('selected Date ${_selectedDate}');
        debugPrint('selected Date to ${state.selectedDateTo}');
        return WillPopScope(
          onWillPop: () async {
            Navigator.of(context).pushNamedAndRemoveUntil(
                RouteConstants.homeRoute, (Route<dynamic> route) => false);
            return false;
          },
          child: SafeArea(
            child: Scaffold(
              appBar: CustomAppBar(
                title: AppConstants.editEmployee,
                leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          RouteConstants.homeRoute,
                          (Route<dynamic> route) => false);
                    },
                    icon: const Icon(Icons.arrow_back_rounded)),
              ),
              body: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // employee name text field
                        SizedBox(
                          height: screenSize.height * 0.1,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 18.0),
                            child: CustomTextField(
                              labelText: 'Employee Name',
                              prefixIcon: Icons.person,
                              textEditingController: _nameController,
                            ),
                          ),
                        ),

                        // select role dropdown widget
                        SizedBox(
                            height: screenSize.height * 0.055,
                            child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: .0),
                                child: CustomDropdown(
                                  items: AppConstants.menuItems,
                                  selectedValue: dropDownValue,
                                  onChanged: (String? value) {
                                    _roleController.text = value ?? '';
                                  },
                                ))),

                        // this widget is rendering both start and End calendar button
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 18.0),
                          child: GestureDetector(
                              onTap: () {},
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () => showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return calendar(screenSize, true);
                                      },
                                    ),
                                    child: SizedBox(
                                        height: screenSize.height * 0.055,
                                        width: screenSize.width / 2.5,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black38),
                                              borderRadius:
                                                  BorderRadius.circular(2)),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 14.0),
                                                child: SvgPicture.asset(
                                                    AppConstants.calendarImage),
                                              ),
                                              _selectedDate == 'No Date'
                                                  ? Expanded(
                                                      child: Text(
                                                          _selectedDate!,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleMedium),
                                                    )
                                                  : Expanded(
                                                      child: Text(
                                                          formatDate(
                                                              DateTime.parse(
                                                                  _selectedDate!)),
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleMedium),
                                                    )
                                            ],
                                          ),
                                        )),
                                  ),
                                  SizedBox(
                                    child: SvgPicture.asset(
                                        'assets/images/Vector.svg'),
                                  ),
                                  GestureDetector(
                                    onTap: () => showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return calendar(screenSize, false);
                                      },
                                    ),
                                    child: SizedBox(
                                        height: screenSize.height * 0.055,
                                        width: screenSize.width / 2.5,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black38),
                                              borderRadius:
                                                  BorderRadius.circular(2)),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 14.0),
                                                child: SvgPicture.asset(
                                                    AppConstants.calendarImage),
                                              ),
                                              _selectedDateTo == 'No Date'
                                                  ? Expanded(
                                                      child: Text(
                                                          _selectedDateTo!,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleMedium),
                                                    )
                                                  : Expanded(
                                                      child: Text(
                                                          formatDate(DateTime.parse(
                                                              _selectedDateTo!)),
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleMedium),
                                                    )
                                            ],
                                          ),
                                        )),
                                  ),
                                ],
                              )),
                        )
                      ])),

              // this bottom sheet is use to show save and cancel button
              bottomSheet: SizedBox(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomAppButton(
                        onPressed: () {},
                        text: AppConstants.btnCancel,
                        color: Colors.lightBlueAccent.withOpacity(0.1),
                        textColor: Colors.blue,
                        fontSize: 16.0,
                        borderRadius: 4.0,
                        padding: 20.0,
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      CustomAppButton(
                        onPressed: () {
                          final employee = Employee(
                            id: widget.employee.id,
                            name: _nameController.text,
                            profession: _roleController.text,
                            fromDate: _selectedDate.toString(),
                            endDate: _selectedDateTo.toString(),
                          );
                          int compareDate = DateTime.parse(employee.fromDate).compareTo(DateTime.parse(employee.endDate));
                          if(compareDate > 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(AppConstants.endDateCannotLess),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                          else if(DateUtils.isSameDay(DateTime.parse(employee.fromDate), DateTime.parse(employee.endDate))){
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(AppConstants.bothDatesCannotSame),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                          else if (employee.name.isEmpty ||
                              employee.profession.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(AppConstants.formValidationMsg),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }

                          else {
                            BlocProvider.of<EmployeeBloc>(context)
                                .add(UpdateEmployee(employee));
                          }
                        },
                        text: AppConstants.btnSave,
                        color: Colors.blue,
                        textColor: Colors.white,
                        fontSize: 16.0,
                        borderRadius: 4.0,
                        padding: 20.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }
    });
  }

  // calendar top 4 shortcuts buttons
  Widget shortCutButtons(bool isStartDate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                height: 35,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.lightBlueAccent),
                    borderRadius: BorderRadius.circular(4)),
                child: CustomAppButton(
                  onPressed: () {
                    _selectToday(isStartDate);
                    Navigator.pop(context);
                  },
                  text: AppConstants.calendarBtnToday,
                  textColor: Colors.lightBlueAccent,
                  color: Colors.white,
                  borderRadius: 4,
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
                child: Container(
              height: 35,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.lightBlueAccent),
                  borderRadius: BorderRadius.circular(4)),
              child: CustomAppButton(
                onPressed: () {
                  _selectNextTuesday(isStartDate);
                  Navigator.pop(context);
                },
                text: AppConstants.calendarBtnTuesday,
                textColor: Colors.lightBlueAccent,
                color: Colors.white,
                borderRadius: 4,
              ),
            )),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                height: 35,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.lightBlueAccent),
                    borderRadius: BorderRadius.circular(4)),
                child: CustomAppButton(
                  onPressed: () {
                    _selectNextMonday(isStartDate);
                    Navigator.pop(context);
                  },
                  text: AppConstants.calendarBtnMonday,
                  textColor: Colors.lightBlueAccent,
                  color: Colors.white,
                  borderRadius: 4,
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Container(
                height: 35,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.lightBlueAccent),
                    borderRadius: BorderRadius.circular(4)),
                child: CustomAppButton(
                  onPressed: () {
                    _selectNextWeek(isStartDate);
                    Navigator.pop(context);
                  },
                  text: AppConstants.calendarBtnWeek,
                  textColor: Colors.lightBlueAccent,
                  color: Colors.white,
                  borderRadius: 4,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // this widget is rendering calendar below shortcuts button
  Widget calendar(Size screenSize, bool isStartDate) {
    return StatefulBuilder(
      builder: (BuildContext context, setState) {
        return Center(
            // Aligns the container to center
            child: Container(
          // A simplified version of dialog.
          width: screenSize.width * 0.9,
          height: screenSize.height / 1.5,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Material(
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  shortCutButtons(isStartDate),
                  CustomDatePicker(onDateSelected: (date) {
                    debugPrint('callback date----- $date');
                    _focusedDay = date;
                  }),
                  const Divider(
                    thickness: 1.0,
                    color: Colors.grey,
                  ),
                  datePickerFooter(isStartDate),
                ],
              ),
            ),
          ),
        ));
      },
    );
  }

  // this function is use to show cancel and save button on calendar dialogue
  Widget datePickerFooter(isStartDate) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          const SizedBox(),
          const Spacer(),
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomAppButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  text: AppConstants.btnCancel,
                  color: Colors.lightBlueAccent.withOpacity(0.1),
                  textColor: Colors.blue,
                  fontSize: 16.0,
                  borderRadius: 4.0,
                  padding: 18.0,
                ),
                const SizedBox(
                  width: 8,
                ),
                CustomAppButton(
                  onPressed: () {
                    debugPrint('_roleController---- ${_roleController.text}');
                    if (!isStartDate) {
                      _employeeBloc.add(EmployeeFormUpdate(
                        employeeRole: _roleController.text.isEmpty
                            ? AppConstants.menuItems[0]
                            : _roleController.text,
                        selectedDate: DateTime.parse(_selectedDate!),
                        selectedDateTo: _focusedDay,
                      ));
                    } else {
                      _employeeBloc.add(EmployeeFormUpdate(
                        employeeRole: _roleController.text.isEmpty
                            ? AppConstants.menuItems[0]
                            : _roleController.text,
                        selectedDate: _focusedDay,
                        selectedDateTo: DateTime.parse(_selectedDateTo!),
                      ));
                    }
                    Navigator.pop(context);
                  },
                  text: AppConstants.btnSave,
                  color: Colors.blue,
                  textColor: Colors.white,
                  fontSize: 16.0,
                  borderRadius: 4.0,
                  padding: 18.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
