import 'package:atta/entities/restaurant.dart';
import 'package:atta/entities/restaurant_plan.dart';
import 'package:atta/extensions/border_radius_ext.dart';
import 'package:atta/extensions/context_ext.dart';
import 'package:atta/pages/reservation/cubit/reservation_cubit.dart';
import 'package:atta/pages/restaurant_detail/restaurant_detail_page.dart';
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

part 'widgets/select_table.dart';

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

class _ReservationScreen extends StatefulWidget {
  const _ReservationScreen();

  @override
  State<_ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<_ReservationScreen> {
  bool _canScroll = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: SingleChildScrollView(
          physics: _canScroll ? const ScrollPhysics() : const NeverScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(AttaSpacing.m),
            child: BlocBuilder<ReservationCubit, ReservationState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AttaSpacing.m),
                    Text('Reservation', style: AttaTextStyle.header),
                    BlocBuilder<ReservationCubit, ReservationState>(
                      builder: (context, state) {
                        return SelectHourly(
                          openingTimes: state.restaurant.openingHoursSlots,
                          selectedDate: state.selectedDate,
                          selectedOpeningTime: state.selectedOpeningTime,
                          onDateChanged: (date) {
                            context.read<ReservationCubit>().selectDate(date);
                          },
                          onOpeningTimeChanged: (openingTime) {
                            context.read<ReservationCubit>().selectOpeningTime(openingTime);
                          },
                        );
                      },
                    ),
                    const SizedBox(height: AttaSpacing.m),
                    Text('Pour combien de personnes ?', style: AttaTextStyle.content),
                    const SizedBox(height: AttaSpacing.s),
                    AttaNumber(
                      onChange: (value) => context.read<ReservationCubit>().onNumberOfPersonsChanged(value),
                      initialValue: context.read<ReservationCubit>().state.numberOfPersons,
                    ),
                    const SizedBox(height: AttaSpacing.l),
                    Text('Choisi ta place', style: AttaTextStyle.content),
                    const SizedBox(height: AttaSpacing.s),
                    SizedBox(
                      width: double.infinity,
                      height: 260,
                      child: BlocBuilder<ReservationCubit, ReservationState>(
                        builder: (context, state) {
                          return Listener(
                            onPointerUp: (_) => setState(() => _canScroll = true),
                            onPointerMove: (_) {
                              setState(() => _canScroll = false);
                            },
                            child: _SelectTable(
                              numberOfSeats: state.numberOfPersons,
                              selectedTableId: state.selectedTableId,
                              onTableSelected: (tableId) => context.read<ReservationCubit>().onTableSelected(tableId),
                              // TODO(florian): Replace with real data
                              tables: mockTables,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: AttaSpacing.l),
                    if (state.reservation != null) ...[
                      Text('Plats commandés', style: AttaTextStyle.content),
                      const SizedBox(height: AttaSpacing.s),
                      ...(state.reservation!.dishs?.keys ?? []).map((dish) {
                        final quantity = state.reservation!.dishs![dish] ?? 0;
                        return FormulaCard(formula: dish, quantity: quantity);
                        // return Text('${dish.name} x$quantity');
                      }),
                      const SizedBox(height: AttaSpacing.l),
                    ],
                    Text('Commentaire', style: AttaTextStyle.content),
                    const SizedBox(height: AttaSpacing.s),
                    TextField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AttaRadius.small),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        contentPadding: const EdgeInsets.all(AttaSpacing.s),
                        hintText: 'Je suis allergique aux fruits à coque...',
                      ),
                    ),
                    const SizedBox(height: AttaSpacing.l),
                    BlocSelector<ReservationCubit, ReservationState, bool>(
                      selector: (state) => state.selectedOpeningTime != null,
                      builder: (context, isButtonEnabled) {
                        return ElevatedButton(
                          onPressed: isButtonEnabled ? () {} : null,
                          child: const Text('Réserver'),
                        );
                      },
                    ),
                    const SizedBox(height: AttaSpacing.l),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
