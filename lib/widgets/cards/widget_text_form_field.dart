//imports flutter

import 'package:flutter/material.dart';

class WidgetTextFormField extends StatefulWidget {
  final TextEditingController? textController;
  final String? textEmptyField;
  final bool? isPassword;
  final Icon? icon;
  final Icon? suffixIcon;
  final String? hintText;
  final Function? onEditingComplete;
  final TextInputType? inputType;
  final TextInputAction? inputAction;
  final Function? onSearch;

  const WidgetTextFormField({
    this.textController,
    this.textEmptyField,
    this.isPassword,
    this.icon,
    this.suffixIcon,
    this.hintText,
    this.onEditingComplete,
    this.inputType,
    this.inputAction,
    this.onSearch,
  });

  @override
  _WidgetTextFormFieldState createState() => _WidgetTextFormFieldState();
}

class _WidgetTextFormFieldState extends State<WidgetTextFormField> {


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textController,
      autofocus: true,
      // todo: receber os validadores do elemento que chamar
      validator: this.widget.textEmptyField == null
          ? null
          : (value) {
              if (value!.isEmpty) return widget.textEmptyField ?? null;
              return null;
            },
      // onEditingComplete:  this.widget.onEditingComplete!() ?? null,
      obscureText: this.widget.isPassword ?? false,
      textInputAction: this.widget.inputAction != null
          ? this.widget.inputAction
          : TextInputAction.done,
      keyboardType: this.widget.inputType != null
          ? this.widget.inputType
          : TextInputType.text,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 20),
        icon: this.widget.icon ?? null,
        hintText: widget.hintText ?? '',
        filled: true,
        fillColor: Colors.white,
        suffixIcon: widget.suffixIcon ?? null,
        hintStyle: TextStyle(color: Colors.black, fontSize: 18),
        border: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(12.0),
        ),
      ),
    );
  }

}
