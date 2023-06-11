import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.selectedValue;
  }

  @override
  Widget build(BuildContext context) {
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
                value: _selectedValue,
                icon: Icon(Icons.arrow_drop_down,color: Theme.of(context).primaryColor,),
                hint:  Text('Select Role',style: Theme.of(context).textTheme.labelLarge),
                items: widget.items.map((T value) {
                  return DropdownMenuItem<T>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
                onChanged: (T? newValue) {
                  setState(() {
                    _selectedValue = newValue;
                  });
                  widget.onChanged(newValue);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
