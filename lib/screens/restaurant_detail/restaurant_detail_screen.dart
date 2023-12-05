import 'package:atta/entities/filter.dart';
import 'package:atta/entities/formula.dart';
import 'package:atta/entities/restaurant.dart';
import 'package:atta/extensions/border_radius_ext.dart';
import 'package:atta/extensions/context_ext.dart';
import 'package:atta/screens/dish_detail/dish_detail.dart';
import 'package:atta/screens/home/home_screen.dart';
import 'package:atta/screens/restaurant_detail/cubit/restaurant_detail_cubit.dart';
import 'package:atta/theme/colors.dart';
import 'package:atta/theme/radius.dart';
import 'package:atta/theme/spacing.dart';
import 'package:atta/theme/text_style.dart';
import 'package:atta/widgets/bottom_navigation_bar.dart';
import 'package:atta/widgets/formula_card.dart';
import 'package:atta/widgets/search_bar.dart';
import 'package:atta/widgets/select_hourly.dart';
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

  RestaurantDetailScreenArgument.fromPathParameters(Map<String, String> parameters) : restaurantId = parameters['id']!;

  final String restaurantId;

  Map<String, String> toPathParameters() => {
        'id': restaurantId,
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

  final String restaurantId;

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
            sliver: BlocBuilder<RestaurantDetailCubit, RestaurantDetailState>(
              builder: (context, state) {
                final selectedFormulaFilter = state.selectedFormulaFilter;
                final formulaList = <AttaFormula>[];

                if (selectedFormulaFilter == null || selectedFormulaFilter == AttaFormulaFilter.dish) {
                  formulaList.addAll(state.restaurant.dishes);
                }
                if (selectedFormulaFilter == null || selectedFormulaFilter == AttaFormulaFilter.menu) {
                  formulaList.addAll(state.restaurant.menus);
                }

                if (state.isOnSearch) {
                  formulaList.retainWhere(
                    (f) => f.name.toLowerCase().contains(state.searchValue.toLowerCase()),
                  );
                }

                return formulaList.isEmpty
                    ? const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Text('Aucun résultat'),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildListDelegate(
                          formulaList
                              .map((e) => FormulaCard(
                                    formula: e,
                                    onTap: () {
                                      // TODO(florian): a ajuster pour les menus
                                      context.adapativePushNamed(
                                        DishDetailPage.routeName,
                                        pathParameters: DishDetailScreenArgument(
                                          restaurantId: restaurantId,
                                          dishId: e.id,
                                        ).toPathParameters(),
                                      );
                                    },
                                  ))
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
