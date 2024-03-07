import 'package:atta/entities/dish.dart';
import 'package:atta/entities/reservation.dart';
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

part 'widgets/dish_type_list.dart';

class MenuDetailPageArgument {
  const MenuDetailPageArgument({
    required this.restaurantId,
    required this.menuId,
    this.reservationMenu,
  });

  MenuDetailPageArgument.fromParameters({required Map<String, String> pathParameters, Object? extra})
      : restaurantId = int.parse(pathParameters['restaurantId']!),
        menuId = int.parse(pathParameters['menuId']!),
        reservationMenu = extra as AttaMenuReservation?;

  Map<String, String> toPathParameters() => {
        'restaurantId': restaurantId.toString(),
        'menuId': menuId.toString(),
      };

  Object? toExtra() => reservationMenu;

  static const String parametersPath = ':restaurantId/:menuId';

  final int restaurantId;
  final int menuId;
  final AttaMenuReservation? reservationMenu;

  MenuDetailPageArgument copyWith({
    int? restaurantId,
    int? menuId,
    AttaMenuReservation? reservationMenu,
  }) {
    return MenuDetailPageArgument(
      restaurantId: restaurantId ?? this.restaurantId,
      menuId: menuId ?? this.menuId,
      reservationMenu: reservationMenu ?? this.reservationMenu,
    );
  }
}

class MenuDetailPage {
  static const path = '/menu_detail/${MenuDetailPageArgument.parametersPath}';
  static const routeName = 'menu_detail';

  static Widget getScreen(MenuDetailPageArgument args) {
    return BlocProvider(
      create: (context) => MenuDetailCubit(
        restaurantId: args.restaurantId,
        menuId: args.menuId,
        reservationMenu: args.reservationMenu,
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
    final isEditable = context.read<MenuDetailCubit>().state.isEditable;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.adaptativePopNamed(
            RestaurantDetailPage.routeName,
            pathParameters: RestaurantDetailPageArgument(
              restaurantId: context.read<MenuDetailCubit>().state.restaurant.id,
            ).toPathParameters(),
          ),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
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
              bottom: MediaQuery.paddingOf(context).bottom + AttaSpacing.s,
              left: AttaSpacing.m,
              right: AttaSpacing.m,
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<MenuDetailCubit>().addMenuToReservation();
                        context.adaptativePopNamed(
                          RestaurantDetailPage.routeName,
                          pathParameters: RestaurantDetailPageArgument(
                            restaurantId: context.read<MenuDetailCubit>().state.restaurant.id,
                          ).toPathParameters(),
                        );
                      },
                      child: Text(
                        context.read<MenuDetailCubit>().state.isEditable ? 'Modifier le panier' : 'Ajouter au panier',
                        style: AttaTextStyle.button,
                      ),
                    ),
                  ),
                  if (isEditable) ...[
                    const SizedBox(width: AttaSpacing.xxs),
                    IconButton(
                      onPressed: () {
                        context.read<MenuDetailCubit>().removeMenuFromReservation();
                        context.adaptativePopNamed(
                          RestaurantDetailPage.routeName,
                          pathParameters: RestaurantDetailPageArgument(
                            restaurantId: context.read<MenuDetailCubit>().state.restaurant.id,
                          ).toPathParameters(),
                        );
                      },
                      icon: Icon(Icons.delete, color: AttaColors.black),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
