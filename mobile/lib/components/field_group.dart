import 'package:flutter/material.dart';

class FieldGroup extends StatelessWidget {
  final String title;
  final Widget child;

  const FieldGroup({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 4),
        child,
      ],
    );
  }
}
