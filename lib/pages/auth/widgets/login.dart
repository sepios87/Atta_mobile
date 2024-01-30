part of '../auth_page.dart';

class _LoginContent extends StatelessWidget {
  const _LoginContent();

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String? email;
    String? password;

    return Column(
      children: [
        const SizedBox(height: AttaSpacing.l),
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
          child: BlocSelector<AuthCubit, AttaAuthState, AuthStatus>(
            selector: (state) => state.status,
            builder: (context, status) {
              return Column(
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
                    onPressed: () {
                      if (status is AuthLoadingForgetPasswordStatus) return;
                      formKey.currentState?.save();
                      if (email == null || email!.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Veuillez entrer votre email')),
                        );
                        return;
                      }
                      context.read<AuthCubit>().onSendForgetPassword(email ?? '').then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Un email vous a été envoyé sur $email pour réinitialiser votre mot de passe'),
                          ),
                        );
                      });
                    },
                    child: status is AuthLoadingForgetPasswordStatus
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AttaColors.black,
                            ),
                          )
                        : const Text('Mot de passe oublié ?'),
                  ),
                  const SizedBox(height: AttaSpacing.l),
                  ElevatedButton(
                    onPressed: () {
                      if (status is AuthLoadingStatus) return;
                      if (formKey.currentState!.validate()) {
                        formKey.currentState?.save();
                        context.read<AuthCubit>().onSendLogin(email ?? '', password ?? '');
                      }
                    },
                    child: status is AuthLoadingStatus
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Se connecter'),
                  ),
                ],
              );
            },
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
        BlocSelector<AuthCubit, AttaAuthState, AuthStatus>(
          selector: (state) => state.status,
          builder: (context, status) {
            if (status is AuthLoadingGoogleStatus) {
              return Container(
                width: 38,
                height: 38,
                padding: const EdgeInsets.all(AttaSpacing.xxs),
                child: CircularProgressIndicator(
                  color: AttaColors.black,
                ),
              );
            }

            return InkWell(
              onTap: () => context.read<AuthCubit>().signInWithGoogle(),
              child: Image.asset(
                'assets/icons/google.png',
                width: 38,
                height: 38,
              ),
            );
          },
        ),
        const SizedBox(height: AttaSpacing.l),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () => context.read<AuthCubit>().onRegister(),
            child: Text('Créer un compte', style: AttaTextStyle.caption),
          ),
        ),
      ],
    );
  }
}
