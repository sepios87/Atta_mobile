import 'package:atta/extensions/border_radius_ext.dart';
import 'package:atta/extensions/context_ext.dart';
import 'package:atta/extensions/num_ext.dart';
import 'package:atta/pages/dish_detail/cubit/dish_detail_cubit.dart';
import 'package:atta/pages/restaurant_detail/restaurant_detail_page.dart';
import 'package:atta/theme/colors.dart';
import 'package:atta/theme/radius.dart';
import 'package:atta/theme/spacing.dart';
import 'package:atta/theme/text_style.dart';
import 'package:atta/widgets/bottom_navigation_bar.dart';
import 'package:atta/widgets/number.dart';
import 'package:atta/widgets/skeleton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'widgets/app_bar.dart';
part 'widgets/dish_image.dart';

class DishDetailScreenArgument {
  const DishDetailScreenArgument({
    required this.restaurantId,
    required this.dishId,
  });

  DishDetailScreenArgument.fromPathParameters(Map<String, String> parameters)
      : restaurantId = int.parse(parameters['restaurantId']!),
        dishId = int.parse(parameters['dishId']!);

  Map<String, String> toPathParameters() => {
        'restaurantId': restaurantId.toString(),
        'dishId': dishId.toString(),
      };

  static const String parametersPath = ':restaurantId/:dishId';

  final int restaurantId;
  final int dishId;
}

class DishDetailPage {
  static const path = '/dish_detail/${DishDetailScreenArgument.parametersPath}';
  static const routeName = 'dish_detail';

  static Widget getScreen(DishDetailScreenArgument args) {
    return BlocProvider(
      create: (context) => DishDetailCubit(
        restaurantId: args.restaurantId,
        dishId: args.dishId,
      ),
      child: _DishDetailScreen(
        restaurantId: args.restaurantId,
      ),
    );
  }
}

class _DishDetailScreen extends StatelessWidget {
  const _DishDetailScreen({
    required this.restaurantId,
  });

  final int restaurantId;

  @override
  Widget build(BuildContext context) {
    final imageSize = MediaQuery.sizeOf(context).height * 0.5;
    final dish = context.read<DishDetailCubit>().state.dish;

    return Scaffold(
      appBar: _AppBar(restaurantId: restaurantId),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: AttaColors.white,
          borderRadius: BorderRadiusExt.top(AttaRadius.medium),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: AttaSpacing.l + AttaSpacing.m + 42),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AttaSpacing.l),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AttaSpacing.m),
                    child: Text(dish.name, style: AttaTextStyle.bigHeader),
                  ),
                  const SizedBox(height: AttaSpacing.l),
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox(width: AttaSpacing.m),
                        AttaNumber(
                          isVertical: true,
                          initialValue: context.read<DishDetailCubit>().state.quantity,
                          onChange: (value) => context.read<DishDetailCubit>().changeQuantity(value),
                        ),
                        const Spacer(),
                        Transform.translate(
                          offset: Offset(imageSize / 6, 0),
                          child: _DishImage(imageUrl: dish.imageUrl),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AttaSpacing.xl),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AttaSpacing.m),
                    child: Text(
                      'Description',
                      style: AttaTextStyle.header,
                    ),
                  ),
                  const SizedBox(height: AttaSpacing.s),
                  if (dish.description != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AttaSpacing.m),
                      child: Text(
                        dish.description!,
                        style: AttaTextStyle.content,
                      ),
                    ),
                  const SizedBox(height: AttaSpacing.m),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AttaSpacing.m),
                    child: Text(
                      'Ingredients',
                      style: AttaTextStyle.header,
                    ),
                  ),
                  const SizedBox(height: AttaSpacing.s),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AttaSpacing.m),
                    child: Text(
                      dish.ingredients,
                      style: AttaTextStyle.content,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: AttaSpacing.m,
                  right: AttaSpacing.m,
                  bottom: AttaSpacing.m,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    context.read<DishDetailCubit>().addToCart();
                    context.adaptativePopNamed(
                      RestaurantDetailPage.routeName,
                      pathParameters: RestaurantDetailScreenArgument(restaurantId: restaurantId).toPathParameters(),
                    );
                  },
                  child: BlocBuilder<DishDetailCubit, DishDetailState>(
                    builder: (context, state) {
                      return Text(
                        'Ajouter au panier (${state.quantity}) - ${(state.dish.price * state.quantity).toEuro}',
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AttaBottomNavigationBar(),
    );
  }
}
