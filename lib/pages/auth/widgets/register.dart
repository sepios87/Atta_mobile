part of '../auth_page.dart';

class _RegisterContent extends StatelessWidget {
  const _RegisterContent();

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String? email;
    String? password;

    return Column(
      children: [
        const SizedBox(height: AttaSpacing.xl),
        Text('Enregistre toi', style: AttaTextStyle.header.copyWith(fontSize: 36)),
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
                // Use onChanged to update the password variable and use it in confirm password field
                onChanged: (value) => password = value,
              ),
              const SizedBox(height: AttaSpacing.m),
              _PasswordField(
                hintText: 'Confirmer le mot de passe',
                validator: (value) {
                  if (value != password) {
                    return 'Les mots de passe ne correspondent pas';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AttaSpacing.xxl),
              BlocSelector<AuthCubit, AttaAuthState, AuthStatus>(
                selector: (state) => state.status,
                builder: (context, status) {
                  return ElevatedButton(
                    onPressed: () {
                      if (status is AuthLoadingStatus) return;
                      if (formKey.currentState!.validate()) {
                        formKey.currentState?.save();
                        context.read<AuthCubit>().onCreateAccount(email ?? '', password ?? '');
                      }
                    },
                    child: status is AuthLoadingStatus
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Créer son compte'),
                  );
                },
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
            onPressed: () => context.read<AuthCubit>().onLogin(),
            child: const Text('Se connecter'),
          ),
        ),
      ],
    );
  }
}
