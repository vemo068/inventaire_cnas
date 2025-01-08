
import 'package:flutter/material.dart';

class TxtFldPC extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final double width;
  final bool autofocus;

  const TxtFldPC({
    super.key,
    required this.hint,
    required this.controller,
    this.width = 300.0,
    this.autofocus=false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextField(
        autofocus: autofocus,
        controller: controller,
        decoration: InputDecoration(
          labelText: hint,
        ),
      ),
    );
  }
}
