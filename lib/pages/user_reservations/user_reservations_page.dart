import 'package:atta/entities/reservation.dart';
import 'package:atta/extensions/border_radius_ext.dart';
import 'package:atta/extensions/context_ext.dart';
import 'package:atta/extensions/date_time_ext.dart';
import 'package:atta/main.dart';
import 'package:atta/pages/home/home_page.dart';
import 'package:atta/pages/restaurant_detail/restaurant_detail_page.dart';
import 'package:atta/pages/user_reservations/cubit/user_reservations_cubit.dart';
import 'package:atta/theme/colors.dart';
import 'package:atta/theme/radius.dart';
import 'package:atta/theme/spacing.dart';
import 'package:atta/theme/text_style.dart';
import 'package:atta/widgets/app_bar.dart';
import 'package:atta/widgets/bottom_navigation/bottom_navigation_bar.dart';
import 'package:atta/widgets/skeleton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'widgets/reservation_card.dart';

class UserReservationsPage {
  static const path = '/user-reservations';
  static const routeName = 'user-reservations';

  static Widget getScreen() => BlocProvider(
        create: (context) => UserReservationsCubit(),
        child: const _UserReservations(),
      );
}

class _UserReservations extends StatelessWidget {
  const _UserReservations();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserReservationsCubit, UserReservationsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AttaAppBar(user: state.user),
          body: Container(
            constraints: const BoxConstraints.expand(),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadiusExt.top(AttaRadius.medium),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: AttaSpacing.m),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AttaSpacing.m),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AttaSpacing.m),
                    child: Text('Vos réservations', style: AttaTextStyle.header),
                  ),
                  const SizedBox(height: AttaSpacing.l),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AttaSpacing.m),
                    child: Text('Pour les prochains jours', style: AttaTextStyle.subHeader),
                  ),
                  const SizedBox(height: AttaSpacing.m),
                  if (state.user.reservations.isEmpty) ...[
                    const Text("Vous n'avez pas encore de réservations"),
                    const SizedBox(height: AttaSpacing.l),
                    ElevatedButton(
                      onPressed: () => context.adapativePushReplacementNamed(HomePage.routeName),
                      child: const Text('Découvrir de nouveaux restaurants'),
                    ),
                  ] else
                    ...state.user.reservations.map(_ReservationCard.new),
                ],
              ),
            ),
          ),
          bottomNavigationBar: const AttaBottomNavigationBar(),
        );
      },
    );
  }
}
