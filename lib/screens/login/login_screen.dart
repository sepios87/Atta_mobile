import 'package:atta/extensions/border_radius_ext.dart';
import 'package:atta/extensions/context_ext.dart';
import 'package:atta/screens/home/home_screen.dart';
import 'package:atta/theme/colors.dart';
import 'package:atta/theme/radius.dart';
import 'package:atta/theme/spacing.dart';
import 'package:atta/theme/text_style.dart';
import 'package:flutter/material.dart';

class LoginPage {
  static const path = '/login';
  static const routeName = 'login';

  static Widget getScreen() => const _LoginScreen();
}

class _LoginScreen extends StatelessWidget {
  const _LoginScreen();

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => context.adaptativePopNamed(HomePage.routeName),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(AttaSpacing.xl),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadiusExt.top(AttaRadius.medium),
        ),
        child: Column(
          children: [
            const SizedBox(height: AttaSpacing.xl),
            Text('Hello', style: AttaTextStyle.header.copyWith(fontSize: 36)),
            const SizedBox(height: AttaSpacing.xl),
            Text(
              '''
Bienvenue sur ATTA, l'application parfaite pour vous mettre à table ! 
Commencez par créer votre compte pour pouvoir réserver une table dans votre restaurant préféré.
                ''',
              textAlign: TextAlign.center,
              style: AttaTextStyle.content,
            ),
            const SizedBox(height: AttaSpacing.l),
            Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AttaSpacing.m),
                  const _PasswordField(),
                  const SizedBox(height: AttaSpacing.m),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Mot de passe oublié ?'),
                  ),
                  const SizedBox(height: AttaSpacing.l),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        print('login');
                      }
                    },
                    child: const Text('Se connecter'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AttaSpacing.xxl),
            Row(
              children: [
                Flexible(
                  child: Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: AttaSpacing.s),
                Text(
                  'Ou continuer avec',
                  style: AttaTextStyle.caption.copyWith(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: AttaSpacing.s),
                Flexible(
                  child: Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: const Text('Créer un compte'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PasswordField extends StatefulWidget {
  const _PasswordField();

  @override
  State<_PasswordField> createState() => __PasswordFieldState();
}

class __PasswordFieldState extends State<_PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Mot de passe',
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
