import 'package:atta/extensions/border_radius.dart';
import 'package:atta/theme/radius.dart';
import 'package:atta/theme/spacing.dart';
import 'package:atta/theme/text_style.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(AttaSpacing.xl),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadiusExt.top(AttaRadius.radiusMedium),
        ),
        child: Column(
          children: [
            const SizedBox(height: AttaSpacing.xl),
            Text('Hello', style: AttaTextStyle.header.copyWith(fontSize: 36)),
            const SizedBox(height: AttaSpacing.xl),
            Text(
              '''
Bienvenue sur ATTA, l’application parfaite pour vous mettre à table ! 
Commencez par créer votre compte pour pouvoir réserver une table dans votre restaurant préféré.
                ''',
              textAlign: TextAlign.center,
              style: AttaTextStyle.content,
            ),
            const SizedBox(height: AttaSpacing.l),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Se connecter'),
            ),
            const SizedBox(height: AttaSpacing.l),
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
            )
          ],
        ),
      ),
    );
  }
}
