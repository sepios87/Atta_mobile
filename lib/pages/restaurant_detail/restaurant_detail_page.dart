import 'package:atta/entities/dish.dart';
import 'package:atta/entities/filter.dart';
import 'package:atta/entities/menu.dart';
import 'package:atta/entities/restaurant.dart';
import 'package:atta/extensions/border_radius_ext.dart';
import 'package:atta/extensions/context_ext.dart';
import 'package:atta/extensions/num_ext.dart';
import 'package:atta/main.dart';
import 'package:atta/pages/dish_detail/dish_detail_page.dart';
import 'package:atta/pages/home/home_page.dart';
import 'package:atta/pages/reservation/reservation_page.dart';
import 'package:atta/pages/restaurant_detail/cubit/restaurant_detail_cubit.dart';
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
                        ? const SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: AttaSpacing.m, bottom: AttaSpacing.xl),
                                child: Text('Aucun résultat'),
                              ),
                            ),
                          )
                        : SliverList(
                            delegate: SliverChildListDelegate(
                              state.filteredFormulas.map((e) {
                                final dishsReservation = state.reservation?.dishs;

                                return FormulaCard(
                                  formula: e,
                                  badge: dishsReservation?[e] == null
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
                                                dishsReservation?[e].toString() ?? '',
                                                style: AttaTextStyle.caption.copyWith(
                                                  color: AttaColors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                  onTap: () {
                                    if (e is AttaMenu) {
                                      // TODO(florian): a ajuster pour les menus
                                    } else if (e is AttaDish) {
                                      context
                                          .adapativePushNamed<bool>(
                                            DishDetailPage.routeName,
                                            pathParameters: DishDetailPageArgument(
                                              restaurantId: state.restaurant.id,
                                              dishId: e.id,
                                            ).toPathParameters(),
                                          )
                                          .then(
                                            (value) => context.read<RestaurantDetailCubit>().updateReservation(),
                                          );
                                    }
                                  },
                                );
                              }).toList(),
                            ),
                          );
                  },
                ),
              ),
              const SliverPadding(padding: EdgeInsets.only(bottom: AttaSpacing.m + 48)),
            ],
          ),
          Positioned(
            bottom: AttaSpacing.m,
            left: AttaSpacing.m,
            right: AttaSpacing.m,
            child: BlocBuilder<RestaurantDetailCubit, RestaurantDetailState>(
              builder: (context, state) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: state.selectedOpeningTime != null ||
                          (state.reservation != null && (state.reservation!.dishs?.isNotEmpty ?? false))
                      ? ElevatedButton(
                          key: const ValueKey('reservation_button'),
                          onPressed: () => context.adapativePushNamed(
                            ReservationPage.routeName,
                            pathParameters: ReservationPageArgument(
                              restaurantId: state.restaurant.id,
                            ).toPathParameters(),
                          ),
                          child: Text(
                            state.reservation?.dishs?.isEmpty ?? true
                                ? 'Réserver sans commander'
                                : 'Commander et réserver (${state.reservation!.totalAmount.toEuro})',
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
