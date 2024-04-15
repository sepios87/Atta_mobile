import 'package:atta/entities/restaurant.dart';
import 'package:atta/entities/restaurant_plan.dart';
import 'package:atta/extensions/border_radius_ext.dart';
import 'package:atta/extensions/context_ext.dart';
import 'package:atta/extensions/widget_ext.dart';
import 'package:atta/main.dart';
import 'package:atta/pages/dish_detail/dish_detail_page.dart';
import 'package:atta/pages/menu_detail/menu_detail_page.dart';
import 'package:atta/pages/reservation/cubit/reservation_cubit.dart';
import 'package:atta/pages/restaurant_detail/restaurant_detail_page.dart';
import 'package:atta/pages/user_reservations/user_reservations_page.dart';
import 'package:atta/theme/animation.dart';
import 'package:atta/theme/colors.dart';
import 'package:atta/theme/radius.dart';
import 'package:atta/theme/spacing.dart';
import 'package:atta/theme/text_style.dart';
import 'package:atta/widgets/formula_card.dart';
import 'package:atta/widgets/number.dart';
import 'package:atta/widgets/select_hourly.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:go_router/go_router.dart';
import 'package:panorama/panorama.dart';

part 'widgets/reservation_content.dart';
part 'widgets/select_table.dart';
part 'modals/preview_restaurant_modal.dart';

class ReservationPageArgument {
  const ReservationPageArgument({required this.restaurantId});

  ReservationPageArgument.fromPathParameters(Map<String, String> pathParameters)
      : restaurantId = int.parse(pathParameters['id']!);

  final int restaurantId;

  Map<String, String> toPathParameters() => {
        'id': restaurantId.toString(),
      };

  static const String parametersPath = ':id';
}

class ReservationPage {
  static const path = '/reservation/${ReservationPageArgument.parametersPath}';
  static const routeName = 'reservation';

  static Widget getScreen(ReservationPageArgument args) => BlocProvider(
        create: (context) => ReservationCubit(
          restaurantId: args.restaurantId,
        ),
        child: const _ReservationScreen(),
      );
}

class _ReservationScreen extends StatelessWidget {
  const _ReservationScreen();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReservationCubit, ReservationState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        final status = state.status;

        if (status is ReservationSuccessStatus) {
          context.goNamed(UserReservationsPage.routeName);
        }

        if (status is ReservationErrorStatus) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(status.message),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BlocSelector<ReservationCubit, ReservationState, AttaRestaurant>(
            selector: (state) => state.restaurant,
            builder: (context, restaurant) {
              return IconButton(
                onPressed: () => context.adaptativePopNamed(
                  RestaurantDetailPage.routeName,
                  pathParameters: RestaurantDetailPageArgument(restaurantId: restaurant.id).toPathParameters(),
                ),
                icon: const Icon(Icons.arrow_back_ios_new),
              );
            },
          ),
        ),
        body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadiusExt.top(AttaRadius.medium),
          ),
          child: const SafeArea(
            child: _ReservationContent(),
          ),
        ),
      ),
    );
  }
}
