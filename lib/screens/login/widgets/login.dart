part of '../login_screen.dart';

class _LoginContent extends StatelessWidget {
  const _LoginContent();

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String? email;
    String? password;

    return Column(
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
                onSaved: (value) => email = value,
                decoration: const InputDecoration(hintText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AttaSpacing.m),
              _PasswordField(
                hintText: 'Mot de passe',
                onSaved: (value) => password = value,
              ),
              const SizedBox(height: AttaSpacing.m),
              TextButton(
                onPressed: () {},
                child: const Text('Mot de passe oublié ?'),
              ),
              const SizedBox(height: AttaSpacing.l),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState?.save();
                    context.read<AuthCubit>().onSendLogin(email ?? '', password ?? '');
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
              'Ou',
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
        const SizedBox(height: AttaSpacing.xxl),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () => context.read<AuthCubit>().onRegister(),
            child: const Text('Créer un compte'),
          ),
        ),
      ],
    );
  }
}
