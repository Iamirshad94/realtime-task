import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:realtime_task/bloc/employee_bloc_event.dart';

import '../bloc/employee_bloc.dart';
import '../bloc/employee_bloc_state.dart';
import 'constants.dart';

class CustomDropdown<T> extends StatefulWidget {
  final List<T> items;
  final T? selectedValue;
  final ValueChanged<T?> onChanged;
  final Widget? prefixIcon;

  const CustomDropdown({
    Key? key,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    this.prefixIcon,
  }) : super(key: key);

  @override
  _CustomDropdownState<T> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  T? _selectedValue;
  late EmployeeBloc _employeeBloc;

  @override
  void initState() {
    super.initState();
    _employeeBloc = BlocProvider.of<EmployeeBloc>(context);
    _selectedValue = widget.selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeeBloc, EmployeeState>(builder: (context, state) {
      if (state is EmployeeFromState) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(2.0),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: SvgPicture.asset(AppConstants.roleImage),
                ),
              ),
              Expanded(
                flex: 6,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<T>(
                    value: state.employeeRole,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Theme.of(context).primaryColor,
                    ),
                    hint: Text('Select Role',
                        style: Theme.of(context).textTheme.labelLarge),
                    items: widget.items.map((T value) {
                      return DropdownMenuItem<T>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }).toList(),
                    onChanged: (T? newValue) {
                      _employeeBloc.add(EmployeeFormUpdate(employeeRole: newValue,));
                      widget.onChanged(newValue);
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      }
      return const SizedBox();
    });
  }
}
