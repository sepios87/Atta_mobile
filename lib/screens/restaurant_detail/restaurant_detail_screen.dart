import 'package:atta/extensions/border_radius_ext.dart';
import 'package:atta/screens/restaurant_detail/cubit/restaurant_detail_cubit.dart';
import 'package:atta/theme/colors.dart';
import 'package:atta/theme/radius.dart';
import 'package:atta/theme/spacing.dart';
import 'package:atta/theme/text_style.dart';
import 'package:atta/widgets/bottom_navigation_bar.dart';
import 'package:atta/widgets/item_card.dart';
import 'package:atta/widgets/search_bar.dart';
import 'package:atta/widgets/select_hourly.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher_string.dart';

class RestaurantDetailScreenArgument {
  const RestaurantDetailScreenArgument({
    required this.restaurantId,
  });

  final String restaurantId;
}

class RestaurantDetailScreen extends StatelessWidget {
  const RestaurantDetailScreen({
    required this.arguments,
    super.key,
  });

  final RestaurantDetailScreenArgument arguments;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RestaurantDetailCubit(
        restaurantId: arguments.restaurantId,
      ),
      child: BlocBuilder<RestaurantDetailCubit, RestaurantDetailState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AttaColors.white,
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.favorite_border),
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.network(
                      state.restaurant.imageUrl,
                      fit: BoxFit.fill,
                    ),
                  ),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(82 + AttaSpacing.m),
                    child: Padding(
                      padding: const EdgeInsets.only(top: AttaSpacing.m),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(
                          left: AttaSpacing.m,
                          right: AttaSpacing.m,
                          top: AttaSpacing.xxs,
                          bottom: AttaSpacing.m,
                        ),
                        decoration: BoxDecoration(
                          color: AttaColors.white,
                          borderRadius: BorderRadiusExt.top(AttaRadius.medium),
                        ),
                        child: SelectHourly(
                          openingTimes: state.restaurant.openingTimes,
                          selectedDate: state.selectedDate,
                          selectedOpeningTime: state.selectedOpeningTime,
                          onDateChanged: (date) {
                            context.read<RestaurantDetailCubit>().selectDate(date);
                          },
                          onOpeningTimeChanged: (openingTime) {
                            context.read<RestaurantDetailCubit>().selectOpeningTime(openingTime);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
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
                          state.restaurant.name,
                          style: AttaTextStyle.bigHeader.copyWith(
                            color: AttaColors.secondary,
                          ),
                        ),
                        const SizedBox(height: AttaSpacing.s),
                        Row(
                          children: [
                            if (state.restaurant.category.isNotEmpty)
                              Row(
                                children: [
                                  const Icon(Icons.food_bank_outlined),
                                  const SizedBox(width: AttaSpacing.xxs),
                                  Text(state.restaurant.category.first.name),
                                ],
                              ),
                            const SizedBox(width: AttaSpacing.xs),
                            Expanded(
                              child: TextButton.icon(
                                onPressed: () => launchUrlString(
                                  'https://www.google.com/maps/search/?api=1&query=${state.restaurant.address}',
                                ),
                                icon: const Icon(Icons.location_on_outlined),
                                label: Text(
                                  state.restaurant.address,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => launchUrlString(state.restaurant.website),
                              icon: const Icon(CupertinoIcons.globe),
                            ),
                            IconButton(
                              onPressed: () => launchUrlString('tel:${state.restaurant.phone}'),
                              icon: const Icon(Icons.phone_outlined),
                            ),
                          ],
                        ),
                        const SizedBox(height: AttaSpacing.m),
                        Text(state.restaurant.description),
                        const SizedBox(height: AttaSpacing.m),
                        AttaSearchBar(
                          onFocus: (isOnFocus) {},
                          onSearch: (value) {},
                        ),
                      ],
                    ),
                  ),
                ),
                DecoratedSliver(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [...state.restaurant.dishes.map(DishItemCard.new)],
                    ),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: const AttaBottomNavigationBar(),
          );
        },
      ),
    );
  }
}
