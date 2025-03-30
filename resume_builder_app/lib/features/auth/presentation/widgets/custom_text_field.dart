import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final void Function(String)? onChanged;
  final FocusNode? focusNode;

  const CustomTextField({
    super.key,
    this.labelText,
    this.hintText,
    this.obscureText = false,
    this.controller,
    this.validator,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        keyboardType: keyboardType,
        focusNode: focusNode,
        onChanged: onChanged,
        style: TextStyle(
          fontSize: 16,
          color: isDark ? theme.colorScheme.onSurface : theme.colorScheme.onSurface,
        ),
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: isDark ? theme.colorScheme.surface : theme.colorScheme.surface.withValues(alpha: 0.1),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 16.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: isDark ? theme.colorScheme.onSurface.withValues(alpha: 0.1) : theme.colorScheme.onSurface.withValues(alpha: 0.1),
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
              width: 2.0,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: theme.colorScheme.error,
              width: 1.0,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: theme.colorScheme.error,
              width: 2.0,
            ),
          ),
          labelStyle: TextStyle(
            color: isDark ? theme.colorScheme.onSurface.withValues(alpha: 0.7) : theme.colorScheme.onSurface.withValues(alpha: 0.7),
            fontSize: 14,
          ),
          hintStyle: TextStyle(
            color: isDark ? theme.colorScheme.onSurface.withValues(alpha: 0.5) : theme.colorScheme.onSurface.withValues(alpha: 0.5),
            fontSize: 14,
          ),
          errorStyle: TextStyle(
            color: theme.colorScheme.error,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
