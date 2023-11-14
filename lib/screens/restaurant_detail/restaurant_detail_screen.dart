import 'package:atta/extensions/border_radius_ext.dart';
import 'package:atta/screens/restaurant_detail/cubit/restaurant_detail_cubit.dart';
import 'package:atta/theme/colors.dart';
import 'package:atta/theme/radius.dart';
import 'package:atta/theme/spacing.dart';
import 'package:atta/theme/text_style.dart';
import 'package:atta/widgets/select_hourly.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                    preferredSize: const Size.fromHeight(78 + AttaSpacing.m),
                    child: Padding(
                      padding: const EdgeInsets.only(top: AttaSpacing.m),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AttaColors.white,
                          borderRadius: BorderRadiusExt.top(AttaRadius.medium),
                        ),
                        child: SelectHourly(),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AttaSpacing.m,
                      vertical: AttaSpacing.l,
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
                                  const Icon(Icons.table_restaurant_outlined),
                                  const SizedBox(width: AttaSpacing.xxs),
                                  Text(state.restaurant.category.first.toString()),
                                ],
                              ),
                            const SizedBox(width: AttaSpacing.l),
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined),
                                const SizedBox(width: AttaSpacing.xxs),
                                Text(state.restaurant.address),
                              ],
                            ),
                          ],
                        ),
                        // Text(state.restaurant.description),
                        const SizedBox(height: AttaSpacing.l),
                        Container(
                          height: 1000,
                          color: Colors.blue,
                        ),
                        Container(
                          height: 1000,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                ),
                // SliverList(
                //   delegate: SliverChildListDelegate(
                //     [
                //       Text(state.restaurant.name),
                //       Text(state.restaurant.description),
                //       Container(
                //         height: 1000,
                //         color: Colors.red,
                //       ),
                //       Container(
                //         height: 1000,
                //         color: Colors.blue,
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          );
        },
      ),
    );
  }
}
