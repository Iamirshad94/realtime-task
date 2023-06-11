import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:realtime_task/utility/constants.dart';
import 'package:realtime_task/utility/custom_appbar.dart';
import 'package:realtime_task/utility/custom_dropdown.dart';
import 'package:table_calendar/table_calendar.dart';
import '../utility/custom_button.dart';
import '../utility/custom_textfield.dart';

class EditEmployeeDetails extends StatefulWidget {
  @override
  State<EditEmployeeDetails> createState() => _EditEmployeeDetailsState();
}

class _EditEmployeeDetailsState extends State<EditEmployeeDetails> {
  final TextEditingController _nameController=TextEditingController();
  final TextEditingController _roleController=TextEditingController();
  final TextEditingController _dateController=TextEditingController();
  final TextEditingController _idController=TextEditingController();
  late String _selectedDate;
  List<String> menuItems = ['Item 1', 'Item 2', 'Item 3'];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now().toString();
  }

  String? dropDownValue;
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
          appBar: const CustomAppBar(title: AppConstants.editEmployee,actions: [
            Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(Icons.delete,color: Colors.white,),
            )
          ],),
          body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
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
                              items: menuItems,
                              selectedValue: dropDownValue,
                              onChanged: (String? value) {},
                            ))),

                    // select date & time widgets in row
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 18.0),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,

                            builder: (BuildContext context) {
                              return StatefulBuilder(builder: (BuildContext context,setState){
                                return  Center( // Aligns the container to center
                                    child: Container( // A simplified version of dialog.
                                      width: screenSize.width*0.9,
                                      height: screenSize.height/1.5,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12)
                                      ),
                                      child: Material(
                                        borderRadius: BorderRadius.circular(12),
                                        child:  Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              shortCutButtons(),
                                              buildCalendar(),
                                              const Divider(
                                                thickness: 1.0,
                                                color: Colors.grey,
                                              ),
                                              datePickerFooter(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                );
                              },);
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
                                  Text(AppConstants.selectDate,
                                      style: Theme.of(context).textTheme.labelLarge)
                                ],
                              ),
                            )),
                      ),
                    )
                  ])),
          bottomSheet: SizedBox(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomAppButton(
                    onPressed: () {
                      // Action to perform when the button is pressed
                    },
                    text: 'Cancel',
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
                      // Action to perform when the button is pressed
                    },
                    text: 'Save',
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
        ));
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
                  onPressed: () {},
                  text: 'Today',
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
                    onPressed: () {},
                    text: 'Next Tuesday',
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
                  onPressed: () {},
                  text: 'Next Monday',
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
                  onPressed: () {},
                  text: 'After 1 Week',
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


  Widget buildCalendar() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Expanded(
            child: TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: DateTime.now(),
              shouldFillViewport: false,
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekdayStyle: TextStyle(fontSize: 12),
                weekendStyle: TextStyle(fontSize: 12),
              ),
              calendarStyle: CalendarStyle(
                canMarkersOverflow: false,
                defaultTextStyle: const TextStyle(fontSize: 12),
                weekendTextStyle: const TextStyle(fontSize: 12),
                todayDecoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.lightBlueAccent)),
                todayTextStyle: const TextStyle(
                    fontSize: 12, color: Colors.lightBlueAccent),
                selectedTextStyle:
                const TextStyle(fontSize: 12, color: Colors.white),
                selectedDecoration: const BoxDecoration(
                    color: Colors.blue, shape: BoxShape.circle),
              ),
              headerStyle: const HeaderStyle(
                  titleCentered: true, formatButtonVisible: false),
              onDaySelected: (selectedDay, focusedDay) {
                debugPrint('selected day $selectedDay');
                DateTime? dateSelected;
                if (!isSameDay(dateSelected, selectedDay)) {
                  // Call `setState()` when updating the selected day
                  setState(() {
                    dateSelected = selectedDay;
                    _selectedDate = dateSelected.toString();
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }


  Widget datePickerFooter() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SvgPicture.asset(AppConstants.calendarImage),
              ),
              Text('05-10-2023',style: Theme.of(context).textTheme.titleSmall,),
            ],
          ),
          const Spacer(),
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomAppButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  text: 'Cancel',
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
                    Navigator.pop(context);
                  },
                  text: 'Save',
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
