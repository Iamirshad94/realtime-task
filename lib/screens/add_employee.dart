import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:realtime_task/bloc/employee_bloc.dart';
import 'package:realtime_task/bloc/employee_bloc_event.dart';
import 'package:realtime_task/repository/database.dart';
import 'package:realtime_task/utility/constants.dart';
import 'package:realtime_task/utility/custom_appbar.dart';
import 'package:realtime_task/utility/custom_dropdown.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:table_calendar/table_calendar.dart';
import '../bloc/employee_bloc_state.dart';
import '../models/employee_model.dart';
import '../utility/custom_button.dart';
import '../utility/custom_datepicker.dart';
import '../utility/custom_textfield.dart';

class AddEmployeeScreen extends StatefulWidget {
  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  String? dropDownValue;
  EmployeeRepository? repository;
  String? _selectedDate;
  DateTime? _focusedDay;
  late EmployeeBloc _employeeBloc;


  @override
  void initState() {
    super.initState();
    _employeeBloc = BlocProvider.of<EmployeeBloc>(context);
    _employeeBloc.add(EmployeeFormUpdate(selectedDate: DateTime.now()));
  }

  void _selectToday() {
    _employeeBloc.add(EmployeeFormUpdate(
        employeeRole: _roleController.text, selectedDate: DateTime.now()));
  }

  void _selectNextMonday() {
    _employeeBloc.add(EmployeeFormUpdate(
        employeeRole: _roleController.text,
        selectedDate: _getNextWeekday(DateTime.monday)));
  }

  void _selectNextTuesday() {
    _employeeBloc.add(EmployeeFormUpdate(
        employeeRole: _roleController.text,
        selectedDate: _getNextWeekday(DateTime.tuesday)));
  }

  void _selectNextWeek() {
    _employeeBloc.add(EmployeeFormUpdate(
        employeeRole: _roleController.text,
        selectedDate: DateTime.now().add(const Duration(days: 7))));
  }

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

  String formatDate(DateTime dateTime) {
    return DateFormat.yMMMMd()
        .format(dateTime); // will give output as March 1, 2023
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
        _selectedDate = formatDate(state.selectedDate ?? DateTime.now());
        return SafeArea(
          child: Scaffold(
            appBar: const CustomAppBar(title: AppConstants.addEmployee),
            body: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
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
                              padding: const EdgeInsets.symmetric(vertical: .0),
                              child: CustomDropdown(
                                items: AppConstants.menuItems,
                                selectedValue: dropDownValue,
                                onChanged: (String? value) {
                                  _roleController.text = value ?? '';
                                },
                              ))),

                      // select date & time widgets in row
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18.0),
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                  builder: (BuildContext context, setState) {
                                    return Center(
                                        // Aligns the container to center
                                        child: Container(
                                      // A simplified version of dialog.
                                      width: screenSize.width * 0.9,
                                      height: screenSize.height / 1.5,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Material(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              shortCutButtons(),
                                              calendar(),
                                              const Divider(
                                                thickness: 1.0,
                                                color: Colors.grey,
                                              ),
                                              datePickerFooter(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ));
                                  },
                                );
                              },
                            );
                          },
                          child: SizedBox(
                              height: screenSize.height * 0.055,
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black38),
                                    borderRadius: BorderRadius.circular(2)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14.0),
                                      child: SvgPicture.asset(
                                          AppConstants.calendarImage),
                                    ),
                                    Text(_selectedDate!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium)
                                  ],
                                ),
                              )),
                        ),
                      )
                    ])),
            bottomSheet: SizedBox(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
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
                          name: _nameController.text,
                          profession: _roleController.text,
                          dateTime: _selectedDate.toString(),
                        );
                        if (employee.name.isEmpty ||
                            employee.profession.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(
                                  AppConstants.formValidationMsg),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        } else {
                          BlocProvider.of<EmployeeBloc>(context)
                              .add(AddEmployee(employee));
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
        );
      }
    });
  }

  Widget shortCutButtons() {
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
                    _selectToday();
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
                  _selectNextTuesday();
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
                    _selectNextMonday();
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
                    _selectNextWeek();
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

  Widget calendar() {
    return CustomDatePicker(onDateSelected: (date) {
      debugPrint('callback date----- $date');
      _focusedDay = date;
    });
  }

  Widget datePickerFooter() {
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
                    _employeeBloc.add(EmployeeFormUpdate(
                        employeeRole: _roleController.text,
                        selectedDate: _focusedDay));
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
