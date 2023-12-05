import 'package:atta/entities/dish.dart';
import 'package:atta/extensions/border_radius_ext.dart';
import 'package:atta/extensions/context_ext.dart';
import 'package:atta/screens/dish_detail/cubit/dish_detail_cubit.dart';
import 'package:atta/screens/restaurant_detail/restaurant_detail_screen.dart';
import 'package:atta/theme/colors.dart';
import 'package:atta/theme/radius.dart';
import 'package:atta/theme/spacing.dart';
import 'package:atta/theme/text_style.dart';
import 'package:atta/widgets/bottom_navigation_bar.dart';
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
      : restaurantId = parameters['restaurantId']!,
        dishId = parameters['dishId']!;

  Map<String, String> toPathParameters() => {
        'restaurantId': restaurantId,
        'dishId': dishId,
      };

  static const String parametersPath = ':restaurantId/:dishId';

  final String restaurantId;
  final String dishId;
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

  final String restaurantId;

  @override
  Widget build(BuildContext context) {
    final imageSize = MediaQuery.sizeOf(context).height * 0.5;

    return Scaffold(
      appBar: _AppBar(restaurantId: restaurantId),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: AttaColors.white,
          borderRadius: BorderRadiusExt.top(AttaRadius.medium),
        ),
        child: BlocSelector<DishDetailCubit, DishDetailState, AttaDish>(
          selector: (state) => state.dish,
          builder: (context, dish) {
            return SingleChildScrollView(
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
                    height: imageSize,
                    width: double.infinity,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          right: -imageSize / 4,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AttaSpacing.m),
                    child: Text(
                      dish.description,
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
                      dish.ingredients.join(', '),
                      style: AttaTextStyle.content,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: const AttaBottomNavigationBar(),
    );
  }
}