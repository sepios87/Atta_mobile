import 'package:atta/entities/dish.dart';
import 'package:atta/entities/filter.dart';
import 'package:atta/entities/formula.dart';
import 'package:atta/entities/menu.dart';
import 'package:atta/entities/restaurant.dart';
import 'package:atta/extensions/border_radius_ext.dart';
import 'package:atta/extensions/context_ext.dart';
import 'package:atta/main.dart';
import 'package:atta/pages/dish_detail/dish_detail_page.dart';
import 'package:atta/pages/home/home_page.dart';
import 'package:atta/pages/restaurant_detail/cubit/restaurant_detail_cubit.dart';
import 'package:atta/theme/colors.dart';
import 'package:atta/theme/radius.dart';
import 'package:atta/theme/spacing.dart';
import 'package:atta/theme/text_style.dart';
import 'package:atta/widgets/bottom_navigation/bottom_navigation_bar.dart';
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

class RestaurantDetailScreenArgument {
  const RestaurantDetailScreenArgument({
    required this.restaurantId,
  });

  RestaurantDetailScreenArgument.fromPathParameters(Map<String, String> parameters)
      : restaurantId = int.parse(parameters['id']!);

  final int restaurantId;

  Map<String, String> toPathParameters() => {
        'id': restaurantId.toString(),
      };

  static const String parametersPath = ':id';
}

class RestaurantDetailPage {
  static const path = '/restaurant-detail/${RestaurantDetailScreenArgument.parametersPath}';
  static const routeName = 'restaurant-detail';

  static Widget getScreen(RestaurantDetailScreenArgument arg) => BlocProvider(
        create: (context) => RestaurantDetailCubit(
          restaurantId: arg.restaurantId,
        ),
        child: _RestaurantDetailScreen(
          restaurantId: arg.restaurantId,
        ),
      );
}

class _RestaurantDetailScreen extends StatelessWidget {
  const _RestaurantDetailScreen({
    required this.restaurantId,
  });

  final int restaurantId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AttaColors.white,
      body: CustomScrollView(
        slivers: [
          const _AppBar(),
          const _Header(),
          DecoratedSliver(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            sliver: BlocSelector<RestaurantDetailCubit, RestaurantDetailState, List<AttaFormula>>(
              selector: (state) => state.filteredFormulas,
              builder: (context, filteredFormulas) {
                return filteredFormulas.isEmpty
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
                          filteredFormulas
                              .map(
                                (e) => FormulaCard(
                                  formula: e,
                                  onTap: () {
                                    if (e is AttaMenu) {
                                      // TODO(florian): a ajuster pour les menus
                                    } else if (e is AttaDish) {
                                      context.adapativePushNamed(
                                        DishDetailPage.routeName,
                                        pathParameters: DishDetailScreenArgument(
                                          restaurantId: restaurantId,
                                          dishId: e.id,
                                        ).toPathParameters(),
                                      );
                                    }
                                  },
                                ),
                              )
                              .toList(),
                        ),
                      );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AttaBottomNavigationBar(),
    );
  }
}
