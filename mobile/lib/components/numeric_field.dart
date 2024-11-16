import 'package:flutter/material.dart';

class NumericField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool decimal;

  const NumericField({
    Key? key,
    required this.controller,
    required this.label,
    required this.hint,
    this.decimal = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: decimal),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, insira $label';
        }

        if (decimal && double.tryParse(value) == null) {
          return 'Digite um número válido';
        }
        return null;
      },
      onChanged: (value) {
        controller.value = TextEditingValue(
          text: value.replaceAll(',', '.'),
          selection: TextSelection.fromPosition(
            TextPosition(offset: value.length),
          ),
        );
      },
    );
  }
}
