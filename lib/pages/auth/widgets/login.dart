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
                    decoration: InputDecoration(hintText: translate('auth_page.email')),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return translate('auth_page.required_email');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AttaSpacing.m),
                  _PasswordField(
                    hintText: translate('auth_page.password'),
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
                          SnackBar(content: Text(translate('auth_page.email_sent'))),
                        );
                      });
                    },
                    child: status is AuthLoadingForgetPasswordStatus
                        ? SizedBox.square(
                            dimension: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AttaColors.black,
                            ),
                          )
                        : Text(translate('auth_page.forget_password_button')),
                  ),
                  const SizedBox(height: AttaSpacing.l),
                  ElevatedButton(
                    onPressed: () {
                      if (status is AuthLoadingStatus) return;
                      if (formKey.currentState!.validate()) {
                        formKey.currentState?.save();
                        context.read<AuthCubit>().onSendLogin(email!, password!);
                      }
                    },
                    child: status is AuthLoadingStatus
                        ? const SizedBox.square(
                            dimension: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(translate('auth_page.login_button')),
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
            child: Text(translate('auth_page.create_account_button')),
          ),
        ),
      ],
    );
  }
}
