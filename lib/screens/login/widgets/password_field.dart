part of '../login_screen.dart';

class _PasswordField extends StatefulWidget {
  const _PasswordField({
    required this.hintText,
  });

  final String hintText;

  @override
  State<_PasswordField> createState() => __PasswordFieldState();
}

class __PasswordFieldState extends State<_PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: widget.hintText,
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: AttaSpacing.xs),
          child: IconButton(
            onPressed: () {
              setState(() => _obscureText = !_obscureText);
            },
            icon: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
              color: AttaColors.secondary.withOpacity(0.6),
            ),
          ),
        ),
      ),
      obscureText: _obscureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez entrer votre mot de passe';
        }
        return null;
      },
    );
  }
}
