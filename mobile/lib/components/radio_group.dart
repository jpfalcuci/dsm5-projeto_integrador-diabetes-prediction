import 'package:flutter/material.dart';

class RadioGroup<T> extends StatelessWidget {
  final String title;
  final List<T> values;
  final T? selectedValue;
  final ValueChanged<T?> onChanged;
  final Map<T, String> labels;

  const RadioGroup({
    Key? key,
    required this.title,
    required this.values,
    required this.selectedValue,
    required this.onChanged,
    required this.labels,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16)),
        Wrap(
          children: values.map((value) {
            return SizedBox(
              width: MediaQuery.of(context).size.width / 2 - 24,
              child: RadioListTile<T>(
                title: Text(labels[value]!),
                value: value,
                groupValue: selectedValue,
                onChanged: onChanged,
                contentPadding: EdgeInsets.zero,
                visualDensity: const VisualDensity(
                  horizontal: VisualDensity.minimumDensity,
                  vertical: VisualDensity.minimumDensity,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
