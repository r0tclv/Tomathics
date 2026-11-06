import 'package:flutter/material.dart';

import '../tokens/tomathics_spacing.dart';

/// Form field with a consistent visible label, helper text, and validation.
class TomathicsTextField extends StatelessWidget {
  const TomathicsTextField({
    required this.label,
    this.controller,
    this.hint,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.obscureText = false,
    this.required = false,
    this.maxLines = 1,
    this.maxLength,
    super.key,
  }) : assert(maxLines > 0);

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final bool obscureText;
  final bool required;
  final int maxLines;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: Theme.of(context).textTheme.labelLarge),
            if (required) ...[
              const SizedBox(width: TomathicsSpacing.xxs),
              Text(
                '*',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: palette.error,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: TomathicsSpacing.xs),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            helperText: helperText,
            errorText: errorText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            counterText: maxLength == null ? '' : null,
          ),
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          validator: validator,
          onChanged: onChanged,
          enabled: enabled,
          obscureText: obscureText,
          maxLines: obscureText ? 1 : maxLines,
          maxLength: maxLength,
        ),
      ],
    );
  }
}
