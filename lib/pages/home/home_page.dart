import 'package:atta/entities/filter.dart';
import 'package:atta/entities/restaurant.dart';
import 'package:atta/entities/user.dart';
import 'package:atta/extensions/border_radius_ext.dart';
import 'package:atta/extensions/context_ext.dart';
import 'package:atta/extensions/restaurant_ext.dart';
import 'package:atta/pages/dish_detail/dish_detail_page.dart';
import 'package:atta/pages/home/cubit/home_cubit.dart';
import 'package:atta/pages/reservation/reservation_page.dart';
import 'package:atta/pages/restaurant_detail/restaurant_detail_page.dart';
import 'package:atta/theme/animation.dart';
import 'package:atta/theme/colors.dart';
import 'package:atta/theme/radius.dart';
import 'package:atta/theme/spacing.dart';
import 'package:atta/theme/text_style.dart';
import 'package:atta/widgets/app_bar.dart';
import 'package:atta/widgets/bottom_navigation/bottom_navigation_bar.dart';
import 'package:atta/widgets/favorite_button.dart';
import 'package:atta/widgets/formula_card.dart';
import 'package:atta/widgets/restaurant_card.dart';
import 'package:atta/widgets/search_bar.dart';
import 'package:atta/widgets/skeleton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

part 'widgets/restaurant_list.dart';
part 'widgets/filters.dart';
part 'widgets/default_content.dart';
part 'widgets/search_content.dart';
part 'widgets/restaurant_search_card.dart';
part 'modals/restaurant_detail.dart';

class HomePage {
  static const path = '/home';
  static const routeName = 'home';

  static Widget getScreen() => BlocProvider(
        create: (context) => HomeCubit(),
        child: const _HomeScreen(),
      );
}

class _HomeScreen extends StatelessWidget {
  const _HomeScreen();

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listenWhen: (previous, current) => previous.selectedRestaurant != current.selectedRestaurant,
      listener: (context, state) {
        if (state.selectedRestaurant != null) {
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (_) => BlocProvider.value(
              value: context.read<HomeCubit>(),
              child: _RestaurantDetail(state.selectedRestaurant!),
            ),
          ).whenComplete(() {
            context.read<HomeCubit>().onRestaurantUnselected();
          });
        }
      },
      child: BlocSelector<HomeCubit, HomeState, AttaUser?>(
        selector: (state) => state.user,
        builder: (context, user) {
          return Scaffold(
            appBar: AttaAppBar(user: user),
            bottomNavigationBar: const AttaBottomNavigationBar(),
            body: Container(
              constraints: const BoxConstraints.expand(),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadiusExt.top(AttaRadius.medium),
              ),
              child: Column(
                children: [
                  const SizedBox(height: AttaSpacing.l),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AttaSpacing.m),
                    child: AttaSearchBar(
                      onFocus: (isOnFocus) => context.read<HomeCubit>().onSearchFocusChange(isOnFocus),
                      onSearch: (value) => context.read<HomeCubit>().onSearchTextChange(value),
                    ),
                  ),
                  const SizedBox(height: AttaSpacing.s),
                  const _Filters(),
                  const SizedBox(height: AttaSpacing.s),
                  Expanded(
                    child: BlocSelector<HomeCubit, HomeState, bool>(
                      selector: (state) => state.isOnSearch,
                      builder: (context, isOnSearch) {
                        return AnimatedSwitcher(
                          duration: AttaAnimation.mediumAnimation,
                          switchInCurve: Curves.easeInOut,
                          switchOutCurve: Curves.easeInOut,
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, -0.1),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              ),
                            );
                          },
                          layoutBuilder: (currentChild, previousChildren) {
                            return Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                ...previousChildren,
                                if (currentChild != null) currentChild,
                              ],
                            );
                          },
                          child: isOnSearch
                              ? const _SearchContent(key: ValueKey('search_content'))
                              : const _DefaultContent(key: ValueKey('default_content')),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
