import 'package:atta/entities/filter.dart';
import 'package:atta/entities/formula.dart';
import 'package:atta/entities/restaurant.dart';
import 'package:atta/extensions/border_radius_ext.dart';
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
import 'package:sliver_tools/sliver_tools.dart';
import 'package:url_launcher/url_launcher_string.dart';

part 'widgets/app_bar.dart';
part 'widgets/search_bar.dart';

class RestaurantDetailScreenArgument {
  const RestaurantDetailScreenArgument({
    required this.restaurantId,
  });

  final String restaurantId;
}

class RestaurantDetailPage {
  static const path = '/restaurant-detail';

  static Widget getScreen(RestaurantDetailScreenArgument arg) => BlocProvider(
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
      backgroundColor: AttaColors.white,
      body: CustomScrollView(
        slivers: [
          const _AppBar(),
          BlocSelector<RestaurantDetailCubit, RestaurantDetailState, AttaRestaurant>(
            selector: (state) => state.restaurant,
            builder: (context, restaurant) {
              return SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.only(
                    left: AttaSpacing.m,
                    right: AttaSpacing.m,
                    top: AttaSpacing.l,
                    bottom: AttaSpacing.m,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadiusExt.top(AttaRadius.medium),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurant.name,
                        style: AttaTextStyle.bigHeader.copyWith(
                          color: AttaColors.secondary,
                        ),
                      ),
                      const SizedBox(height: AttaSpacing.s),
                      Row(
                        children: [
                          if (restaurant.category.isNotEmpty)
                            Row(
                              children: [
                                const Icon(Icons.food_bank_outlined),
                                const SizedBox(width: AttaSpacing.xxs),
                                Text(restaurant.category.first.name),
                              ],
                            ),
                          const SizedBox(width: AttaSpacing.xs),
                          Expanded(
                            child: TextButton.icon(
                              onPressed: () => launchUrlString(
                                'https://www.google.com/maps/search/?api=1&query=${restaurant.address}',
                              ),
                              icon: const Icon(Icons.location_on_outlined),
                              label: Text(
                                restaurant.address,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => launchUrlString(restaurant.website),
                            icon: const Icon(CupertinoIcons.globe),
                          ),
                          IconButton(
                            onPressed: () => launchUrlString('tel:${restaurant.phone}'),
                            icon: const Icon(Icons.phone_outlined),
                          ),
                        ],
                      ),
                      const SizedBox(height: AttaSpacing.m),
                      Text(restaurant.description),
                    ],
                  ),
                ),
              );
            },
          ),
          const _SearchBar(),
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
                          formulaList.map((e) => FormulaCard(formula: e)).toList(),
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
