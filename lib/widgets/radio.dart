import 'package:flutter/material.dart';

/// A radio group widget that manages a group of radio options.
///
/// This widget uses Flutter's RadioGroup to handle group value management,
/// keyboard navigation, and semantics for radio buttons.
///
/// Example:
/// ```dart
/// RadioView<String>(
///   options: [
///     (value: 'app', label: 'App'),
///     (value: 'package', label: 'Package'),
///   ],
///   selectedValue: selectedValue,
///   onChanged: (value) => setState(() => selectedValue = value),
/// )
/// ```
class RadioView<T> extends StatelessWidget {
  /// List of radio options with their values and labels
  final List<({T value, String label})> options;

  /// The currently selected value in the group
  final T selectedValue;

  /// Callback when the selected value changes
  final ValueChanged<T> onChanged;

  /// Optional spacing between radio items (default: 8.0)
  final double spacing;

  const RadioView({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
    this.spacing = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return RadioGroup<T>(
      groupValue: selectedValue,
      onChanged: (value) {
        if (value != null) {
          onChanged(value);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: spacing,
        children: [
          for (final option in options)
            RadioListTile<T>(
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(option.label),
              value: option.value,
              selected: option.value == selectedValue,
            ),
        ],
      ),
    );
  }
}
