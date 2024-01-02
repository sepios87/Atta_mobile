import 'package:atta/entities/restaurant_plan.dart';
import 'package:atta/extensions/border_radius_ext.dart';
import 'package:atta/extensions/context_ext.dart';
import 'package:atta/screens/reservation/cubit/reservation_cubit.dart';
import 'package:atta/screens/restaurant_detail/restaurant_detail_screen.dart';
import 'package:atta/theme/colors.dart';
import 'package:atta/theme/radius.dart';
import 'package:atta/theme/spacing.dart';
import 'package:atta/theme/text_style.dart';
import 'package:atta/widgets/number.dart';
import 'package:atta/widgets/select_hourly.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'widgets/select_table.dart';

class ReservationPage {
  static const path = '/reservation';
  static const routeName = 'reservation';

  static Widget getScreen() => BlocProvider(
        create: (context) => ReservationCubit(),
        child: const _ReservationScreen(),
      );
}

class _ReservationScreen extends StatelessWidget {
  const _ReservationScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.adaptativePopNamed(
            RestaurantDetailPage.routeName,
            // pathParameters: RestaurantDetailScreenArgument(restaurantId: restaurantId).toPathParameters(),
          ),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadiusExt.top(AttaRadius.medium),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AttaSpacing.m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AttaSpacing.m),
                Text('Reservation', style: AttaTextStyle.header),
                // SelectHourly(
                // openingTimes: state.restaurant.openingTimes,
                // selectedDate: state.selectedDate,
                // selectedOpeningTime: state.selectedOpeningTime,
                // onDateChanged: (date) {
                //   context.read<RestaurantDetailCubit>().selectDate(date);
                // },
                // onOpeningTimeChanged: (openingTime) {
                //   context.read<RestaurantDetailCubit>().selectOpeningTime(openingTime);
                // },
                // ),
                const SizedBox(height: AttaSpacing.m),
                Text('Pour combien de personnes ?', style: AttaTextStyle.content),
                const SizedBox(height: AttaSpacing.s),
                AttaNumber(onChange: (value) {}, quantity: 1),
                const SizedBox(height: AttaSpacing.l),
                Text('Choisi ta place', style: AttaTextStyle.content),
                const SizedBox(height: AttaSpacing.s),
                SizedBox(
                  width: double.infinity,
                  height: 260,
                  child: BlocSelector<ReservationCubit, ReservationState, String?>(
                    selector: (state) => state.selectedTableId,
                    builder: (context, selectedTableId) {
                      return _SelectTable(
                        selectedTableId: selectedTableId,
                        onTableSelected: (tableId) => context.read<ReservationCubit>().onTableSelected(tableId),
                        // TODO(florian): Replace with real data
                        tables: const [
                          AttaTable(id: '1', x: 1, y: 1, numberOfSeats: 2, width: 1, height: 1),
                          AttaTable(id: '2', x: 3, y: 1, numberOfSeats: 5, width: 3, height: 1),
                          AttaTable(id: '3', x: 1, y: 3, numberOfSeats: 2, width: 1, height: 1),
                          AttaTable(id: '4', x: 3, y: 3, numberOfSeats: 6, width: 2, height: 5),
                          AttaTable(id: '5', x: 6, y: 3, numberOfSeats: 2, width: 1, height: 1),
                          AttaTable(id: '6', x: 8, y: 3, numberOfSeats: 2, width: 1, height: 1),
                          AttaTable(id: '7', x: 1, y: 5, numberOfSeats: 2, width: 1, height: 5),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
