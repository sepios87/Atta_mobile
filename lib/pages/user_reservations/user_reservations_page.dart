import 'package:atta/entities/reservation.dart';
import 'package:atta/entities/restaurant.dart';
import 'package:atta/extensions/border_radius_ext.dart';
import 'package:atta/extensions/context_ext.dart';
import 'package:atta/extensions/date_time_ext.dart';
import 'package:atta/extensions/num_ext.dart';
import 'package:atta/extensions/widget_ext.dart';
import 'package:atta/main.dart';
import 'package:atta/pages/restaurant_detail/restaurant_detail_page.dart';
import 'package:atta/pages/user_reservations/cubit/user_reservations_cubit.dart';
import 'package:atta/theme/animation.dart';
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
import 'package:maps_launcher/maps_launcher.dart';
import 'package:share_plus/share_plus.dart';

part 'widgets/reservation_expansion_card.dart';
part 'widgets/title_card_expansion.dart';
part 'widgets/child_card_expansion.dart';
part 'widgets/reservation_formula_detail.dart';
part 'widgets/to_finish_reservation.dart';

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
        final beforeReservation =
            state.user.reservations.where((r) => r.dateTime.isBefore(DateTime.now()) && !r.dateTime.isToday).toList();
        final afterReservation =
            state.user.reservations.where((r) => r.dateTime.isAfter(DateTime.now()) || r.dateTime.isToday).toList();

        final todoList = reservationService.reservations;

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
                    child: SizedBox(
                      height: AttaTextStyle.header.fontSize,
                      width: double.infinity,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Text('Vos réservations', style: AttaTextStyle.header),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: FractionalTranslation(
                              translation: const Offset(0, -0.25),
                              child: state.selectedReservations.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.delete_outline_rounded),
                                      onPressed: () =>
                                          context.read<UserReservationsCubit>().onRemoveAllSelectReservations(),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AttaSpacing.l),

                  Text('A terminer', style: AttaTextStyle.subHeader).withPadding(
                    const EdgeInsets.symmetric(horizontal: AttaSpacing.m),
                  ),
                  const SizedBox(height: AttaSpacing.xs),
                  // TODO(florian): faire passer cette liste dans le cubit et quand on clique pout terminer une réservation et qu'on quitte la page pour revenir ici, ca doit actualiser
                  ...todoList.map((reservation) => _ToFinishReservation(reservation: reservation)),
                  const SizedBox(height: AttaSpacing.l),

                  if (state.withoutReservations)
                    const Text("Vous n'avez pas encore de réservations").withPadding(
                      const EdgeInsets.symmetric(horizontal: AttaSpacing.m),
                    )
                  else ...[
                    if (afterReservation.isNotEmpty) ...[
                      Text('Pour les prochains jours', style: AttaTextStyle.subHeader).withPadding(
                        const EdgeInsets.symmetric(horizontal: AttaSpacing.m),
                      ),
                      const SizedBox(height: AttaSpacing.xs),
                      ...afterReservation.map(
                        (r) => _ReservationCardExpansion(
                          reservation: r,
                          key: ValueKey(r.id),
                        ),
                      ),
                      const SizedBox(height: AttaSpacing.l),
                    ],
                    if (beforeReservation.isNotEmpty) ...[
                      Text('Déja passées', style: AttaTextStyle.subHeader).withPadding(
                        const EdgeInsets.symmetric(horizontal: AttaSpacing.m),
                      ),
                      const SizedBox(height: AttaSpacing.xs),
                      ...beforeReservation.map(
                        (r) => _ReservationCardExpansion(
                          reservation: r,
                          key: ValueKey(r.id),
                        ),
                      ),
                    ],
                  ],
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
