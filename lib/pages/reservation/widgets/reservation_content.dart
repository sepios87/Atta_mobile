part of '../reservation_page.dart';

class _ReservationContent extends StatefulWidget {
  const _ReservationContent();

  @override
  State<_ReservationContent> createState() => _ReservationContentState();
}

class _ReservationContentState extends State<_ReservationContent> {
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
              Text(translate('reservation_page.title'), style: AttaTextStyle.header).withPadding(
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
                      context.read<ReservationCubit>().selectFirstOpeningTime();
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
              Text(translate('reservation_page.number_of_persons'), style: AttaTextStyle.content).withPadding(
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
              Text(translate('reservation_page.select_table'), style: AttaTextStyle.content).withPadding(
                const EdgeInsets.symmetric(horizontal: AttaSpacing.m),
              ),
              const SizedBox(height: AttaSpacing.s),
              if (state.plan != null)
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
                          plan: state.plan!,
                        ),
                      );
                    },
                  ),
                ).withPadding(
                  const EdgeInsets.symmetric(horizontal: AttaSpacing.m),
                ),
              const SizedBox(height: AttaSpacing.l),
              Text(translate('reservation_page.preview_restaurant'), style: AttaTextStyle.content).withPadding(
                const EdgeInsets.symmetric(horizontal: AttaSpacing.m),
              ),
              const SizedBox(height: AttaSpacing.s),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AttaSpacing.m),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AttaRadius.small),
                  child: SizedBox(
                    width: double.infinity,
                    height: 220,
                    child: Stack(
                      children: [
                        Panorama(
                          child: Image.asset('assets/360.jpg'),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: CircleAvatar(
                              radius: 16,
                              backgroundColor: AttaColors.primary,
                              child: Icon(
                                Icons.fullscreen,
                                color: AttaColors.white,
                              ),
                            ),
                            onPressed: () => _showPreviewRestaurantModal(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AttaSpacing.l),
              if (state.reservation.dishIds.isNotEmpty) ...[
                Text(translate('reservation_page.dish_selected'), style: AttaTextStyle.content).withPadding(
                  const EdgeInsets.symmetric(horizontal: AttaSpacing.m),
                ),
                const SizedBox(height: AttaSpacing.s),
                ...state.reservation.dishIds.keys.map((dishId) {
                  final quantity = state.reservation.dishIds[dishId] ?? 0;
                  final dish = restaurantService.getDishById(state.restaurant.id, dishId);
                  if (dish == null) return const SizedBox.shrink();

                  return FormulaCard(
                    formula: dish,
                    quantity: quantity,
                    onTap: () async {
                      await context.adapativePushNamed(
                        DishDetailPage.routeName,
                        pathParameters: DishDetailPageArgument(
                          restaurantId: state.restaurant.id,
                          dishId: dish.id,
                        ).toPathParameters(),
                      );
                      // ignore: use_build_context_synchronously
                      context.read<ReservationCubit>().refreshReservation();
                    },
                  );
                }),
                const SizedBox(height: AttaSpacing.l),
              ],
              if (state.reservation.menus.isNotEmpty) ...[
                Text(translate('reservation_page.menu_selected'), style: AttaTextStyle.content).withPadding(
                  const EdgeInsets.symmetric(horizontal: AttaSpacing.m),
                ),
                const SizedBox(height: AttaSpacing.s),
                ...state.reservation.menus.map((e) {
                  final menu = restaurantService.getMenuById(state.restaurant.id, e.menuId);
                  if (menu == null) return const SizedBox.shrink();

                  return FormulaCard(
                    formula: menu,
                    onTap: () async {
                      final args = MenuDetailPageArgument(
                        restaurantId: state.restaurant.id,
                        menuId: menu.id,
                        reservationMenu: e,
                      );
                      // ignore: use_build_context_synchronously
                      await context.adapativePushNamed(
                        MenuDetailPage.routeName,
                        pathParameters: args.toPathParameters(),
                        extra: args.toExtra(),
                      );
                      // ignore: use_build_context_synchronously
                      context.read<ReservationCubit>().refreshReservation();
                    },
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
              Text(translate('reservation_page.comment'), style: AttaTextStyle.content).withPadding(
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
                  hintText: translate('reservation_page.comment_hint'),
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
                        : Text(translate('reservation_page.reservation_button')),
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
