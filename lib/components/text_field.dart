import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String placeholder;
  final TextInputType inputType;
  final bool obscureText;
  final int maxLines;
  final TextEditingController controller;
  final bool isRequired;
  final int? minLength;
  final int? maxLength;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  CustomTextField({
    required this.label,
    required this.placeholder,
    required this.inputType,
    required this.controller,
    this.obscureText = false,
    this.maxLines = 1,
    this.isRequired = false,
    this.minLength,
    this.maxLength,
    this.validator,
    this.onChanged,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(fontSize: 16, color: Colors.grey[900]),
        ),
        TextFormField(
          maxLines: widget.maxLines,
          controller: widget.controller,
          keyboardType: widget.inputType,
          obscureText: widget.obscureText,
          decoration: InputDecoration(
            hintText: widget.placeholder,
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.red, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.red, width: 2),
            ),
            errorText: _errorMessage,
          ),
          validator: (value) {
            String? error = _validate(value);
            if (error != null) {
              setState(() {
                _errorMessage = error;
              });
              return error;
            }
            setState(() {
              _errorMessage = null;
            });
            return widget.validator?.call(value);
          },
          onChanged: (value) {
            setState(() {
              _errorMessage = _validate(value);
            });
            widget.onChanged?.call(value);
          },
        ),
      ],
    );
  }

  String? _validate(String? value) {
    if (widget.isRequired && (value == null || value.isEmpty)) {
      return 'Este campo es requerido';
    }
    if (widget.minLength != null && value != null && value.length < widget.minLength!) {
      return 'Debe tener al menos ${widget.minLength} caracteres';
    }
    if (widget.maxLength != null && value != null && value.length > widget.maxLength!) {
      return 'Debe tener menos de ${widget.maxLength} caracteres';
    }
    return null;
  }
}