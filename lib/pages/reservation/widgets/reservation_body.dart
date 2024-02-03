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
                }),
                const SizedBox(height: AttaSpacing.l),
              ],
              Text('Commentaire', style: AttaTextStyle.content),
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
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
