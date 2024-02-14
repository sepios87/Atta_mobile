import 'package:atta/entities/dish.dart';
import 'package:atta/extensions/border_radius_ext.dart';
import 'package:atta/extensions/context_ext.dart';
import 'package:atta/extensions/widget_ext.dart';
import 'package:atta/pages/menu_detail/cubit/menu_detail_cubit.dart';
import 'package:atta/pages/restaurant_detail/restaurant_detail_page.dart';
import 'package:atta/theme/colors.dart';
import 'package:atta/theme/radius.dart';
import 'package:atta/theme/spacing.dart';
import 'package:atta/theme/text_style.dart';
import 'package:atta/widgets/formula_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MenuDetailPageArgument {
  const MenuDetailPageArgument({
    required this.restaurantId,
    required this.menuId,
  });

  MenuDetailPageArgument.fromPathParameters(Map<String, String> parameters)
      : restaurantId = int.parse(parameters['restaurantId']!),
        menuId = int.parse(parameters['menuId']!);

  Map<String, String> toPathParameters() => {
        'restaurantId': restaurantId.toString(),
        'menuId': menuId.toString(),
      };

  static const String parametersPath = ':restaurantId/:menuId';

  final int restaurantId;
  final int menuId;
}

class MenuDetailPage {
  static const path = '/menu_detail/${MenuDetailPageArgument.parametersPath}';
  static const routeName = 'menu_detail';

  static Widget getScreen(MenuDetailPageArgument args) {
    return BlocProvider(
      create: (context) => MenuDetailCubit(
        restaurantId: args.restaurantId,
        menuId: args.menuId,
      ),
      child: const _MenuDetailScreen(),
    );
  }
}

class _MenuDetailScreen extends StatelessWidget {
  const _MenuDetailScreen();

  @override
  Widget build(BuildContext context) {
    final menu = context.read<MenuDetailCubit>().state.menu;
    final dishes = context.read<MenuDetailCubit>().state.dishes;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.adaptativePopNamed(
            RestaurantDetailPage.routeName,
            pathParameters: RestaurantDetailPageArgument(
              restaurantId: context.read<MenuDetailCubit>().state.restaurant.id,
            ).toPathParameters(),
          ),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AttaColors.white,
          ),
        ),
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
          color: AttaColors.white,
          borderRadius: BorderRadiusExt.top(AttaRadius.medium),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AttaSpacing.l),
                  Text(menu.name, style: AttaTextStyle.bigHeader).withPadding(
                    const EdgeInsets.symmetric(horizontal: AttaSpacing.m),
                  ),
                  const SizedBox(height: AttaSpacing.l),
                  ...DishType.values.map(
                    (type) => _DishTypeList(
                      type: type,
                      dishes: dishes.where((dish) => dish.type == type).toList(),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: AttaSpacing.m,
              left: AttaSpacing.m,
              right: AttaSpacing.m,
              child: ElevatedButton(
                onPressed: () => context.adaptativePopNamed(
                  RestaurantDetailPage.routeName,
                  pathParameters: RestaurantDetailPageArgument(
                    restaurantId: context.read<MenuDetailCubit>().state.restaurant.id,
                  ).toPathParameters(),
                ),
                child: Text('Ajouter au panier', style: AttaTextStyle.button),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DishTypeList extends StatelessWidget {
  const _DishTypeList({
    required this.type,
    required this.dishes,
  });

  final DishType type;
  final List<AttaDish> dishes;

  @override
  Widget build(BuildContext context) {
    if (dishes.isEmpty) return const SizedBox.shrink();

    return BlocSelector<MenuDetailCubit, MenuDetailState, int>(
      selector: (state) => state.selectedDishIds[type] ?? 0,
      builder: (context, selectedDishId) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(type.translatedName, style: AttaTextStyle.header).withPadding(
              const EdgeInsets.symmetric(horizontal: AttaSpacing.m),
            ),
            const SizedBox(height: AttaSpacing.xxxs),
            ...dishes.map(
              (dish) => FormulaCard(
                formula: dish,
                leading: Radio<int>(
                  value: dish.id,
                  groupValue: selectedDishId,
                  onChanged: (_) {},
                  visualDensity: VisualDensity.compact,
                ),
                onTap: () => context.read<MenuDetailCubit>().selectDish(dish),
              ),
            ),
            const SizedBox(height: AttaSpacing.m),
          ],
        );
      },
    );
  }
}
