import 'package:atta/entities/dish.dart';
import 'package:atta/entities/filter.dart';
import 'package:atta/entities/menu.dart';
import 'package:atta/entities/reservation.dart';
import 'package:atta/entities/restaurant.dart';
import 'package:atta/entities/wrapped.dart';
import 'package:atta/extensions/border_radius_ext.dart';
import 'package:atta/extensions/context_ext.dart';
import 'package:atta/extensions/num_ext.dart';
import 'package:atta/extensions/widget_ext.dart';
import 'package:atta/main.dart';
import 'package:atta/pages/auth/auth_page.dart';
import 'package:atta/pages/dish_detail/dish_detail_page.dart';
import 'package:atta/pages/home/home_page.dart';
import 'package:atta/pages/menu_detail/menu_detail_page.dart';
import 'package:atta/pages/reservation/reservation_page.dart';
import 'package:atta/pages/restaurant_detail/cubit/restaurant_detail_cubit.dart';
import 'package:atta/theme/animation.dart';
import 'package:atta/theme/colors.dart';
import 'package:atta/theme/radius.dart';
import 'package:atta/theme/spacing.dart';
import 'package:atta/theme/text_style.dart';
import 'package:atta/widgets/favorite_button.dart';
import 'package:atta/widgets/formula_card.dart';
import 'package:atta/widgets/search_bar.dart';
import 'package:atta/widgets/select_hourly.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher_string.dart';

part 'widgets/app_bar.dart';
part 'widgets/search_bar.dart';
part 'widgets/header.dart';

part 'bottom_sheet/menu_bottom_sheet.dart';

class RestaurantDetailPageArgument {
  const RestaurantDetailPageArgument({
    required this.restaurantId,
  });

  RestaurantDetailPageArgument.fromPathParameters(Map<String, String> parameters)
      : restaurantId = int.parse(parameters['id']!);

  final int restaurantId;

  Map<String, String> toPathParameters() => {
        'id': restaurantId.toString(),
      };

  static const String parametersPath = ':id';
}

class RestaurantDetailPage {
  static const path = '/restaurant-detail/${RestaurantDetailPageArgument.parametersPath}';
  static const routeName = 'restaurant-detail';

  static Widget getScreen(RestaurantDetailPageArgument arg) => BlocProvider(
        create: (context) => RestaurantDetailCubit(
          restaurantId: arg.restaurantId,
        ),
        child: const _RestaurantDetailScreen(),
      );
}

class _RestaurantDetailScreen extends StatelessWidget {
  const _RestaurantDetailScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AttaColors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              const _AppBar(),
              const _Header(),
              DecoratedSliver(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                sliver: BlocBuilder<RestaurantDetailCubit, RestaurantDetailState>(
                  buildWhen: (previous, current) => previous.filteredFormulas != current.filteredFormulas,
                  builder: (context, state) {
                    return state.filteredFormulas.isEmpty
                        ? SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(
                              child: const Text('Aucun résultat').withPadding(
                                const EdgeInsets.only(top: AttaSpacing.m, bottom: AttaSpacing.xl),
                              ),
                            ),
                          )
                        : SliverList(
                            delegate: SliverChildListDelegate(
                              state.filteredFormulas.map((e) {
                                int? quantity;

                                if (e is AttaMenu) {
                                  quantity = state.reservation?.menus
                                      .fold<int?>(null, (p, m) => e.id == m.menuId ? p = (p ?? 0) + 1 : p);
                                } else if (e is AttaDish) {
                                  quantity = state.reservation?.dishIds[e.id];
                                }

                                return FormulaCard(
                                  formula: e,
                                  badge: quantity == null
                                      ? null
                                      : Container(
                                          decoration: BoxDecoration(
                                            color: AttaColors.secondary,
                                            borderRadius: BorderRadius.circular(AttaRadius.small),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: AttaSpacing.xs,
                                            vertical: AttaSpacing.xxs,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.shopping_basket_rounded,
                                                size: 13,
                                                color: AttaColors.white,
                                              ),
                                              const SizedBox(width: AttaSpacing.xxs),
                                              Text(
                                                quantity.toString(),
                                                style: AttaTextStyle.caption.copyWith(
                                                  color: AttaColors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                  onTap: () async {
                                    if (e is AttaMenu) {
                                      MenuDetailPageArgument args = MenuDetailPageArgument(
                                        restaurantId: state.restaurant.id,
                                        menuId: e.id,
                                      );
                                      if (quantity != null && quantity > 0) {
                                        final reservationMenu = await _showMenuBottomSheet(
                                          context,
                                          menusReservation: state.reservation!.menus.toList(),
                                        );
                                        if (reservationMenu == null) return;
                                        if (reservationMenu.value != null) {
                                          args = args.copyWith(reservationMenu: reservationMenu.value);
                                        }
                                      }
                                      // ignore: use_build_context_synchronously
                                      await context.adapativePushNamed(
                                        MenuDetailPage.routeName,
                                        pathParameters: args.toPathParameters(),
                                        extra: args.toExtra(),
                                      );
                                    } else if (e is AttaDish) {
                                      await context.adapativePushNamed<bool>(
                                        DishDetailPage.routeName,
                                        pathParameters: DishDetailPageArgument(
                                          restaurantId: state.restaurant.id,
                                          dishId: e.id,
                                        ).toPathParameters(),
                                      );
                                    }
                                    // ignore: use_build_context_synchronously
                                    context.read<RestaurantDetailCubit>().updateReservation();
                                  },
                                );
                              }).toList(),
                            ),
                          );
                  },
                ),
              ),
              DecoratedSliver(
                decoration: const BoxDecoration(color: Colors.white),
                sliver: SliverPadding(
                  padding: EdgeInsets.only(bottom: AttaSpacing.m + 48 + MediaQuery.viewInsetsOf(context).bottom),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: AttaSpacing.m,
            left: AttaSpacing.m,
            right: AttaSpacing.m,
            child: BlocBuilder<RestaurantDetailCubit, RestaurantDetailState>(
              builder: (context, state) {
                return AnimatedSwitcher(
                  duration: AttaAnimation.mediumAnimation,
                  child: state.selectedOpeningTime != null ||
                          (state.reservation != null && state.reservation!.withFormulas)
                      ? ElevatedButton(
                          key: const ValueKey('reservation_button'),
                          onPressed: () {
                            if (userService.isLogged) {
                              context.adapativePushNamed(
                                ReservationPage.routeName,
                                pathParameters: ReservationPageArgument(
                                  restaurantId: state.restaurant.id,
                                ).toPathParameters(),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: AttaColors.black,
                                  content: const Text('Vous devez être connecté pour réserver'),
                                  action: SnackBarAction(
                                    textColor: AttaColors.white,
                                    label: 'Se connecter',
                                    onPressed: () => context.adapativePushNamed(AuthPage.routeName),
                                  ),
                                ),
                              );
                            }
                          },
                          child: Text(
                            state.reservation?.withFormulas ?? false
                                ? 'Commander et réserver (${state.totalAmount.toEuro})'
                                : 'Réserver sans commander',
                          ),
                        )
                      : const SizedBox.shrink(key: ValueKey('empty')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
