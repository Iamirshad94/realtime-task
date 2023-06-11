import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final IconData prefixIcon;
  final bool obscureText;
  TextEditingController textEditingController=TextEditingController();

  CustomTextField({
    Key? key,
    required this.labelText,
    required this.textEditingController,
    required this.prefixIcon,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      controller: textEditingController,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: Theme.of(context).textTheme.labelLarge,
        prefixIcon: Icon(prefixIcon,color: Theme.of(context).primaryColor,),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(2.0), // Set the border radius here
          ),
        ),
      ),
    );
  }
}
