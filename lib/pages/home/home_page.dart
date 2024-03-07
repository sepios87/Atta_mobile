import 'package:atta/entities/filter.dart';
import 'package:atta/entities/restaurant.dart';
import 'package:atta/entities/user.dart';
import 'package:atta/extensions/border_radius_ext.dart';
import 'package:atta/extensions/context_ext.dart';
import 'package:atta/extensions/restaurant_ext.dart';
import 'package:atta/extensions/widget_ext.dart';
import 'package:atta/main.dart';
import 'package:atta/pages/dish_detail/dish_detail_page.dart';
import 'package:atta/pages/home/cubit/home_cubit.dart';
import 'package:atta/pages/reservation/reservation_page.dart';
import 'package:atta/pages/restaurant_detail/restaurant_detail_page.dart';
import 'package:atta/theme/animation.dart';
import 'package:atta/theme/colors.dart';
import 'package:atta/theme/radius.dart';
import 'package:atta/theme/spacing.dart';
import 'package:atta/theme/text_style.dart';
import 'package:atta/widgets/favorite_button.dart';
import 'package:atta/widgets/formula_card.dart';
import 'package:atta/widgets/restaurant_card.dart';
import 'package:atta/widgets/search_bar.dart';
import 'package:atta/widgets/skeleton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

part 'widgets/restaurant_list.dart';
part 'widgets/filters.dart';
part 'widgets/default_content.dart';
part 'widgets/search_content.dart';
part 'widgets/map_content.dart';
part 'widgets/restaurant_search_card.dart';
part 'bottom_sheets/restaurant_preview.dart';

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
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height * 0.2,
            ),
            useRootNavigator: true,
            context: context,
            isScrollControlled: true,
            builder: (_) => BlocProvider.value(
              value: context.read<HomeCubit>(),
              child: _RestaurantPreviewBottomSheet(state.selectedRestaurant!),
            ),
          ).whenComplete(() {
            context.read<HomeCubit>().onRestaurantUnselected();
          });
        }
      },
      child: BlocSelector<HomeCubit, HomeState, AttaUser?>(
        selector: (state) => state.user,
        builder: (context, user) {
          return Container(
            constraints: const BoxConstraints.expand(),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadiusExt.top(AttaRadius.medium),
            ),
            child: Column(
              children: [
                const SizedBox(height: AttaSpacing.l),
                Padding(
                  padding: const EdgeInsets.only(left: AttaSpacing.m, right: AttaSpacing.xs),
                  child: AttaSearchBar(
                    onFocus: (isOnFocus) => context.read<HomeCubit>().onSearchFocusChange(isOnFocus),
                    onSearch: (value) => context.read<HomeCubit>().onSearchTextChange(value),
                    inactiveTrailing: BlocSelector<HomeCubit, HomeState, bool>(
                      selector: (state) => state.isOnListView,
                      builder: (context, isOnListView) {
                        return IconButton(
                          padding: EdgeInsets.zero,
                          splashRadius: AttaSpacing.s,
                          onPressed: () => context.read<HomeCubit>().onToogleListView(),
                          icon: isOnListView
                              ? const Icon(CupertinoIcons.map)
                              : const Icon(CupertinoIcons.square_grid_2x2),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: AttaSpacing.s),
                // Necessary key to change the language of the filters when the user changes the language
                _Filters(key: ValueKey('filters-${user?.languageCode}')),
                const SizedBox(height: AttaSpacing.s),
                Expanded(
                  child: BlocBuilder<HomeCubit, HomeState>(
                    buildWhen: (previous, current) =>
                        previous.isOnSearch != current.isOnSearch || previous.isOnListView != current.isOnListView,
                    builder: (context, state) {
                      // Necessary key to change the language of the filters when the user changes the language
                      Widget child = _DefaultContent(key: ValueKey('default_content-${user?.languageCode}'));
                      if (!state.isOnListView) {
                        child = const _MapContent(key: ValueKey('map_content'));
                      }
                      if (state.isOnSearch) {
                        child = const _SearchContent(key: ValueKey('search_content'));
                      }

                      return AnimatedSwitcher(
                        duration: AttaAnimation.mediumAnimation,
                        reverseDuration: AttaAnimation.mediumAnimation,
                        switchInCurve: Curves.easeInOut,
                        switchOutCurve: Curves.easeIn,
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
                        child: child,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
