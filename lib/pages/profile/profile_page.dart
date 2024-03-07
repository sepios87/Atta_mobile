import 'package:atta/bottom_sheet/edit_profile.dart';
import 'package:atta/extensions/border_radius_ext.dart';
import 'package:atta/extensions/context_ext.dart';
import 'package:atta/extensions/locale_ext.dart';
import 'package:atta/extensions/widget_ext.dart';
import 'package:atta/pages/home/home_page.dart';
import 'package:atta/pages/profile/cubit/profile_cubit.dart';
import 'package:atta/theme/colors.dart';
import 'package:atta/theme/radius.dart';
import 'package:atta/theme/spacing.dart';
import 'package:atta/theme/text_style.dart';
import 'package:atta/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';

class ProfilePage {
  static const path = '/profile';
  static const routeName = 'profile';

  static Widget getScreen() => BlocProvider(
        create: (context) => ProfileCubit(),
        child: const _ProfileScreen(),
      );
}

const _kAvatarSize = 42.0;

class _ProfileScreen extends StatelessWidget {
  const _ProfileScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => context.adaptativePopNamed(HomePage.routeName),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: kToolbarHeight + MediaQuery.paddingOf(context).top - _kAvatarSize),
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return Stack(
              children: [
                Positioned(
                  top: _kAvatarSize,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadiusExt.top(AttaRadius.medium),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AttaSpacing.m),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      UserAvatar(user: state.user, radius: _kAvatarSize),
                      const SizedBox(height: AttaSpacing.xl),
                      Text(
                        state.user.email ?? '',
                        textAlign: TextAlign.center,
                        style: AttaTextStyle.header,
                      ),
                      if (state.user.fullName.isNotEmpty) ...[
                        const SizedBox(height: AttaSpacing.s),
                        Text(
                          state.user.fullName,
                          textAlign: TextAlign.center,
                          style: AttaTextStyle.subHeader,
                        ),
                      ],
                      const SizedBox(height: AttaSpacing.xl),
                      IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    state.user.favoritesRestaurantIds.length.toString(),
                                    style: AttaTextStyle.subHeader,
                                  ),
                                  Text(
                                    'Restaurants\nfavoris',
                                    textAlign: TextAlign.center,
                                    style: AttaTextStyle.caption,
                                  ),
                                ],
                              ),
                            ),
                            VerticalDivider(
                              color: AttaColors.primary,
                              thickness: 1,
                            ).withPadding(const EdgeInsets.symmetric(vertical: AttaSpacing.xs)),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    state.user.favoriteDishesIds.length.toString(),
                                    style: AttaTextStyle.subHeader,
                                  ),
                                  Text(
                                    'Plats\nfavoris',
                                    textAlign: TextAlign.center,
                                    style: AttaTextStyle.caption,
                                  ),
                                ],
                              ),
                            ),
                            VerticalDivider(
                              color: AttaColors.primary,
                              thickness: 1,
                            ).withPadding(const EdgeInsets.symmetric(vertical: AttaSpacing.xs)),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    state.user.reservations.length.toString(),
                                    style: AttaTextStyle.subHeader,
                                  ),
                                  Text(
                                    'Réservations\npassées',
                                    textAlign: TextAlign.center,
                                    style: AttaTextStyle.caption,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AttaSpacing.xxl),
                      Material(
                        color: Colors.transparent,
                        child: ListTile(
                          title: Text(translate('profile_page.edit_profile')),
                          subtitle: Text(translate('profile_page.edit_profile_description')),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () => showEditProfileBottomSheet(context, state.user),
                        ),
                      ),
                      const Divider(),
                      Material(
                        color: Colors.transparent,
                        child: ListTile(
                          title: Text(translate('profile_page.change_language')),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () {
                            showDialog<void>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(translate('profile_page.select_language')),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: LocalizedApp.of(context)
                                        .delegate
                                        .supportedLocales
                                        .map(
                                          (locale) => ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            leading: LocalizedApp.of(context).delegate.currentLocale == locale
                                                ? const Icon(Icons.check)
                                                : const SizedBox.square(dimension: 24),
                                            title: Text(locale.languageName),
                                            onTap: () {
                                              changeLocale(context, locale.languageCode);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        )
                                        .toList(),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          translate('profile_page.remove_account_button'),
                          style: AttaTextStyle.caption.copyWith(color: Colors.grey.shade600),
                        ),
                      ),
                      const SizedBox(height: AttaSpacing.xxs),
                      ElevatedButton(
                        onPressed: () {
                          if (state.status is ProfileLoadingLogoutStatus) return;
                          context.read<ProfileCubit>().onLogout().then(
                                (_) => context.adapativeReplacementNamed(HomePage.routeName),
                              );
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: AttaColors.black),
                        child: state.status is ProfileLoadingLogoutStatus
                            ? const SizedBox.square(
                                dimension: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(translate('profile_page.logout_button')),
                      ),
                      const SizedBox(height: AttaSpacing.m),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
