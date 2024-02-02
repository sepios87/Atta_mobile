import 'package:atta/extensions/border_radius_ext.dart';
import 'package:atta/extensions/context_ext.dart';
import 'package:atta/extensions/num_ext.dart';
import 'package:atta/pages/dish_detail/cubit/dish_detail_cubit.dart';
import 'package:atta/pages/home/home_page.dart';
import 'package:atta/theme/colors.dart';
import 'package:atta/theme/radius.dart';
import 'package:atta/theme/spacing.dart';
import 'package:atta/theme/text_style.dart';
import 'package:atta/widgets/number.dart';
import 'package:atta/widgets/skeleton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'widgets/app_bar.dart';
part 'widgets/dish_image.dart';

class DishDetailPageArgument {
  const DishDetailPageArgument({
    required this.restaurantId,
    required this.dishId,
  });

  DishDetailPageArgument.fromPathParameters(Map<String, String> parameters)
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
  static const path = '/dish_detail/${DishDetailPageArgument.parametersPath}';
  static const routeName = 'dish_detail';

  static Widget getScreen(DishDetailPageArgument args) {
    return BlocProvider(
      create: (context) => DishDetailCubit(
        restaurantId: args.restaurantId,
        dishId: args.dishId,
      ),
      child: const _DishDetailScreen(),
    );
  }
}

class _DishDetailScreen extends StatelessWidget {
  const _DishDetailScreen();

  @override
  Widget build(BuildContext context) {
    final imageSize = MediaQuery.sizeOf(context).height * 0.5;
    final dish = context.read<DishDetailCubit>().state.dish;
    final isDeletable = context.read<DishDetailCubit>().state.isDeletable;

    return Scaffold(
      appBar: const _AppBar(),
      body: Container(
        constraints: const BoxConstraints.expand(),
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
                  const SizedBox(height: AttaSpacing.xxl),
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
            Positioned(
              left: AttaSpacing.m,
              right: AttaSpacing.m,
              bottom: AttaSpacing.m,
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<DishDetailCubit>().addDishToReservation();
                        // TODO(florian): si nous sommes sur la version web et qu'on est sur la page réservation ou detail d'un resto avant, il faudrait rediriger vers la page de réservation a nouveau
                        context.adaptativePopNamed(HomePage.routeName, result: true);
                      },
                      child: BlocBuilder<DishDetailCubit, DishDetailState>(
                        builder: (context, state) {
                          return Text(
                            '${isDeletable ? 'Modifier le panier' : 'Ajouter au panier'} (${state.quantity}) - ${(state.dish.price * state.quantity).toEuro}',
                            textAlign: TextAlign.center,
                          );
                        },
                      ),
                    ),
                  ),
                  if (isDeletable) ...[
                    const SizedBox(width: AttaSpacing.xxs),
                    IconButton(
                      onPressed: () {
                        context.read<DishDetailCubit>().removeDishFromReservation();
                        // TODO(florian): si nous sommes sur la version web et qu'on est sur la page réservation ou detail d'un resto avant, il faudrait rediriger vers la page de réservation a nouveau
                        context.adaptativePopNamed(HomePage.routeName, result: true);
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
