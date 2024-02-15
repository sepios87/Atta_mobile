part of '../reservation_page.dart';

class _ReservationBody extends StatefulWidget {
  const _ReservationBody();

  @override
  State<_ReservationBody> createState() => __ReservationBodyState();
}

class __ReservationBodyState extends State<_ReservationBody> {
  bool _canScroll = true;
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: _canScroll ? const ScrollPhysics() : const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: AttaSpacing.m),
      child: BlocBuilder<ReservationCubit, ReservationState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AttaSpacing.m),
              Text('Reservation', style: AttaTextStyle.header).withPadding(
                const EdgeInsets.symmetric(horizontal: AttaSpacing.m),
              ),
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
              ).withPadding(
                const EdgeInsets.symmetric(horizontal: AttaSpacing.m),
              ),
              const SizedBox(height: AttaSpacing.m),
              Text('Pour combien de personnes ?', style: AttaTextStyle.content).withPadding(
                const EdgeInsets.symmetric(horizontal: AttaSpacing.m),
              ),
              const SizedBox(height: AttaSpacing.s),
              AttaNumber(
                onChange: (value) => context.read<ReservationCubit>().onNumberOfPersonsChanged(value),
                initialValue: context.read<ReservationCubit>().state.reservation.numberOfPersons,
              ).withPadding(
                const EdgeInsets.symmetric(horizontal: AttaSpacing.m),
              ),
              const SizedBox(height: AttaSpacing.l),
              Text('Choisi ta place', style: AttaTextStyle.content).withPadding(
                const EdgeInsets.symmetric(horizontal: AttaSpacing.m),
              ),
              const SizedBox(height: AttaSpacing.s),
              SizedBox(
                width: double.infinity,
                height: 260,
                child: BlocBuilder<ReservationCubit, ReservationState>(
                  builder: (context, state) {
                    return Listener(
                      onPointerUp: (_) => setState(() => _canScroll = true),
                      onPointerMove: (_) => setState(() => _canScroll = false),
                      child: _ContainerSelectTable(
                        numberOfSeats: state.reservation.numberOfPersons,
                        selectedTableId: state.reservation.tableId,
                        onTableSelected: (tableId) => context.read<ReservationCubit>().onTableSelected(tableId),
                        // TODO(florian): Replace with real data
                        tables: mockTables,
                      ),
                    );
                  },
                ),
              ).withPadding(
                const EdgeInsets.symmetric(horizontal: AttaSpacing.m),
              ),
              const SizedBox(height: AttaSpacing.l),
              if (state.reservation.dishIds.isNotEmpty) ...[
                Text('Plats commandés', style: AttaTextStyle.content).withPadding(
                  const EdgeInsets.symmetric(horizontal: AttaSpacing.m),
                ),
                const SizedBox(height: AttaSpacing.s),
                ...state.reservation.dishIds.keys.map((dishId) {
                  final quantity = state.reservation.dishIds[dishId] ?? 0;
                  final dish = restaurantService.getDishById(state.restaurant.id, dishId);
                  if (dish == null) return const SizedBox.shrink();

                  return FormulaCard(formula: dish, quantity: quantity);
                }),
                const SizedBox(height: AttaSpacing.l),
              ],
              if (state.reservation.menus.isNotEmpty) ...[
                Text('Menus commandés', style: AttaTextStyle.content).withPadding(
                  const EdgeInsets.symmetric(horizontal: AttaSpacing.m),
                ),
                const SizedBox(height: AttaSpacing.s),
                ...state.reservation.menus.map((e) {
                  final menu = restaurantService.getMenuById(state.restaurant.id, e.menuId);
                  if (menu == null) return const SizedBox.shrink();

                  return FormulaCard(
                    formula: menu,
                    customContent: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...e.selectedDishIds.map((dishId) {
                          final dish = restaurantService.getDishById(state.restaurant.id, dishId);
                          if (dish == null) return const SizedBox.shrink();

                          return Padding(
                            padding: const EdgeInsets.only(bottom: AttaSpacing.xxxs),
                            child: Text(
                              dish.name,
                              overflow: TextOverflow.ellipsis,
                              style: AttaTextStyle.content,
                            ),
                          );
                        }),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: AttaSpacing.l),
              ],
              Text('Commentaire', style: AttaTextStyle.content).withPadding(
                const EdgeInsets.symmetric(horizontal: AttaSpacing.m),
              ),
              const SizedBox(height: AttaSpacing.s),
              TextField(
                controller: _commentController,
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
              ).withPadding(
                const EdgeInsets.symmetric(horizontal: AttaSpacing.m),
              ),
              const SizedBox(height: AttaSpacing.l),
              BlocBuilder<ReservationCubit, ReservationState>(
                buildWhen: (previous, current) =>
                    previous.selectedOpeningTime != current.selectedOpeningTime || previous.status != current.status,
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: state.selectedOpeningTime != null
                        ? () {
                            if (state.status is ReservationLoadingStatus) return;
                            context.read<ReservationCubit>().onSendReservation(comment: _commentController.text);
                          }
                        : null,
                    child: state.status is ReservationLoadingStatus
                        ? SizedBox.square(
                            dimension: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AttaColors.white,
                            ),
                          )
                        : const Text('Réserver'),
                  ).withPadding(const EdgeInsets.symmetric(horizontal: AttaSpacing.m));
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
