import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final VoidCallback onClear;
  final String placeholder;

  CustomSearchBar({
    required this.controller,
    required this.onChanged,
    required this.onClear,
    required this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.black54),
          SizedBox(width: 8.0),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: placeholder,
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.black54),
            onPressed: onClear,
          ),
        ],
      ),
    );
  }
}
