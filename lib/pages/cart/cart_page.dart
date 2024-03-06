import 'package:atta/entities/reservation.dart';
import 'package:atta/extensions/border_radius_ext.dart';
import 'package:atta/extensions/context_ext.dart';
import 'package:atta/extensions/widget_ext.dart';
import 'package:atta/main.dart';
import 'package:atta/pages/cart/cubit/cart_cubit.dart';
import 'package:atta/pages/home/home_page.dart';
import 'package:atta/pages/restaurant_detail/restaurant_detail_page.dart';
import 'package:atta/theme/animation.dart';
import 'package:atta/theme/radius.dart';
import 'package:atta/theme/spacing.dart';
import 'package:atta/theme/text_style.dart';
import 'package:atta/widgets/reservation_formula_detail.dart';
import 'package:atta/widgets/skeleton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'widgets/reservation_cart_card.dart';

class CartPage {
  static const path = '/cart';
  static const routeName = 'cart';

  static Widget getScreen() => BlocProvider(
        create: (context) => CartCubit(),
        child: const _CartScreen(),
      );
}

class _CartScreen extends StatelessWidget {
  const _CartScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.adaptativePopNamed(HomePage.routeName),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadiusExt.top(AttaRadius.medium),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: AttaSpacing.m),
          child: BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AttaSpacing.m),
                  Text('Commandes à terminer', style: AttaTextStyle.header).withPadding(
                    const EdgeInsets.symmetric(horizontal: AttaSpacing.m),
                  ),
                  const SizedBox(height: AttaSpacing.m),
                  ...state.reservations.map(_ReservationCartCard.new),
                  if (state.reservations.isEmpty)
                    Text(
                      'Aucune commande en cours',
                      style: AttaTextStyle.content,
                    ).withPadding(const EdgeInsets.symmetric(horizontal: AttaSpacing.m)),
                  const SizedBox(height: AttaSpacing.l),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
