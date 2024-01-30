import 'package:atta/extensions/border_radius_ext.dart';
import 'package:atta/extensions/context_ext.dart';
import 'package:atta/pages/home/home_page.dart';
import 'package:atta/pages/profile/cubit/profile_cubit.dart';
import 'package:atta/theme/colors.dart';
import 'package:atta/theme/radius.dart';
import 'package:atta/theme/spacing.dart';
import 'package:atta/theme/text_style.dart';
import 'package:atta/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage {
  static const path = '/profile';
  static const routeName = 'profile';

  static Widget getScreen() => BlocProvider(
        create: (context) => ProfileCubit(),
        child: const _ProfileScreen(),
      );
}

class _ProfileScreen extends StatelessWidget {
  const _ProfileScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.adaptativePopNamed(HomePage.routeName),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: Container(
        height: double.infinity,
        padding: const EdgeInsets.all(AttaSpacing.xl),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadiusExt.top(AttaRadius.medium),
        ),
        child: SingleChildScrollView(
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  UserAvatar(user: state.user, radius: 48),
                  const SizedBox(height: AttaSpacing.xl),
                  Text(
                    state.user.email ?? '',
                    textAlign: TextAlign.center,
                    style: AttaTextStyle.header,
                  ),
                  const SizedBox(height: AttaSpacing.xl),
                  Center(
                    child: _StatData(
                      number: state.user.favoritesRestaurantIds.length,
                      label: 'Restaurants\nfavoris',
                    ),
                  ),
                  const SizedBox(height: AttaSpacing.xl),
                  ElevatedButton(
                    onPressed: () {
                      if (state.status is ProfileLoadingLogoutStatus) return;
                      context.read<ProfileCubit>().onLogout().then(
                            (_) => context.adapativeReplacementNamed(HomePage.routeName),
                          );
                    },
                    child: state.status is ProfileLoadingLogoutStatus
                        ? const SizedBox.square(
                            dimension: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Se déconnecter'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _StatData extends StatelessWidget {
  const _StatData({
    required this.number,
    required this.label,
  });

  final int number;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AttaSpacing.xs),
      decoration: BoxDecoration(
        color: AttaColors.secondary,
        borderRadius: BorderRadius.circular(AttaRadius.small),
      ),
      child: Column(
        children: [
          Text(
            number.toString(),
            style: AttaTextStyle.bigHeader.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AttaSpacing.xs),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AttaTextStyle.caption.copyWith(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
