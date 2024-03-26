part of '../auth_page.dart';

class _PasswordField extends StatefulWidget {
  const _PasswordField({
    required this.hintText,
    this.onSaved,
    this.validator,
    this.onChanged,
  });

  final String hintText;
  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;

  @override
  State<_PasswordField> createState() => __PasswordFieldState();
}

class __PasswordFieldState extends State<_PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: widget.onSaved,
      decoration: InputDecoration(
        hintText: widget.hintText,
        suffixIcon: IconButton(
          onPressed: () {
            setState(() => _obscureText = !_obscureText);
          },
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: AttaColors.secondary.withOpacity(0.6),
          ),
        ),
      ),
      obscureText: _obscureText,
      onChanged: (value) => widget.onChanged?.call(value),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return translate('auth_page.required_password');
        }
        return widget.validator?.call(value);
      },
    );
  }
}
