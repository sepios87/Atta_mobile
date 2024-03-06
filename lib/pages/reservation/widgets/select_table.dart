part of '../reservation_page.dart';

class _ContainerSelectTable extends StatelessWidget {
  const _ContainerSelectTable({
    required this.plan,
    required this.selectedTableId,
    required this.onTableSelected,
    required this.numberOfSeats,
  });

  final AttaRestaurantPlan plan;
  final int? selectedTableId;
  final void Function(int? tableId) onTableSelected;
  final int numberOfSeats;

  @override
  Widget build(BuildContext context) {
    final maxTableXPosition = _calculateMaxTableXPosition(plan.tables);
    final maxTableYPosition = _calculateMaxTableYPosition(plan.tables);

    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              color: AttaColors.white,
              borderRadius: BorderRadius.circular(AttaRadius.small),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) => _SelectTable(
                positionedElements: plan.positionedElements,
                selectedTableId: selectedTableId,
                onTableSelected: onTableSelected,
                numberOfSeats: numberOfSeats,
                constraints: constraints,
                maxTableXPosition: maxTableXPosition,
                maxTableYPosition: maxTableYPosition,
              ),
            ),
          ),
        ),
        if (selectedTableId != null)
          Positioned(
            right: AttaSpacing.s,
            bottom: AttaSpacing.xxs,
            child: Text(
              'Table $selectedTableId selectionnée',
              style: AttaTextStyle.caption,
            ),
          ),
      ],
    );
  }
}

class _SelectTable extends StatefulWidget {
  const _SelectTable({
    required this.positionedElements,
    required this.selectedTableId,
    required this.onTableSelected,
    required this.numberOfSeats,
    required this.constraints,
    required this.maxTableXPosition,
    required this.maxTableYPosition,
  });

  final List<AttaPositionnedElement> positionedElements;
  final int? selectedTableId;
  final void Function(int? tableId) onTableSelected;
  final int numberOfSeats;
  final BoxConstraints constraints;
  final double maxTableXPosition;
  final double maxTableYPosition;

  @override
  State<_SelectTable> createState() => _SelectTableState();
}

class _SelectTableState extends State<_SelectTable> {
  final _transformationController = TransformationController();

  @override
  void dispose() {
    _transformationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = widget.constraints.maxHeight;
    final maxWidth = widget.constraints.maxWidth;

    bool isSelectableTable(AttaTable table) {
      return context.read<ReservationCubit>().state.isSelectableTable(table, widget.numberOfSeats);
    }

    return GestureDetector(
      onDoubleTapDown: (details) {
        if (_transformationController.value != Matrix4.identity()) {
          _transformationController.value = Matrix4.identity();
        } else {
          final localPosition = details.localPosition;
          _transformationController.value = Matrix4.identity()
            ..scale(1.5)
            ..translate(-localPosition.dx / 1.5, -localPosition.dy / 1.5);
        }
      },
      onTapUp: (details) {
        final position = _transformationController.toScene(details.localPosition);
        final table = widget.positionedElements.whereType<AttaTable>().firstWhereOrNull(
          (e) {
            final tablePosition = Offset(
              (e.x * maxWidth) / widget.maxTableXPosition,
              (e.y * maxHeight) / widget.maxTableYPosition,
            );
            final tableSize = Size(
              (e.width * maxWidth) / widget.maxTableXPosition,
              (e.height * maxHeight) / widget.maxTableYPosition,
            );
            final tableRect = Rect.fromLTWH(
              tablePosition.dx,
              tablePosition.dy,
              tableSize.width,
              tableSize.height,
            );
            return tableRect.contains(position);
          },
        );
        if (table != null && isSelectableTable(table)) {
          widget.onTableSelected(table.id);
        } else {
          widget.onTableSelected(null);
        }
      },
      child: InteractiveViewer(
        transformationController: _transformationController,
        boundaryMargin: const EdgeInsets.all(AttaSpacing.m),
        maxScale: 3,
        child: Stack(
          clipBehavior: Clip.none,
          children: widget.positionedElements
              .map(
                (t) => switch (t) {
                  final AttaTable table => _Table(
                      table: table,
                      x: (table.x * maxWidth) / widget.maxTableXPosition,
                      y: (table.y * maxHeight) / widget.maxTableYPosition,
                      width: (table.width * maxWidth) / widget.maxTableXPosition,
                      height: (table.height * maxHeight) / widget.maxTableYPosition,
                      isSelected: table.id == widget.selectedTableId,
                      isEnable: isSelectableTable(table),
                    ),
                  final AttaToilets toilets => _Toillet(
                      x: (toilets.x * maxWidth) / widget.maxTableXPosition,
                      y: (toilets.y * maxHeight) / widget.maxTableYPosition,
                    ),
                  final AttaDoor door => _Door(
                      x: (door.x * maxWidth) / widget.maxTableXPosition,
                      y: (door.y * maxHeight) / widget.maxTableYPosition,
                      size: (maxHeight / widget.maxTableYPosition) * 1.5,
                      isVertical: door.isVertical,
                    ),
                  final AttaKitchen kitchen => _Kitchen(
                      x: (kitchen.x * maxWidth) / widget.maxTableXPosition,
                      y: (kitchen.y * maxHeight) / widget.maxTableYPosition,
                    ),
                },
              )
              .toList(),
        ),
      ),
    );
  }
}

class _Toillet extends StatelessWidget {
  const _Toillet({
    required this.x,
    required this.y,
  });

  final double x;
  final double y;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x,
      top: y,
      child: CircleAvatar(
        backgroundColor: AttaColors.accent,
        maxRadius: 16,
        child: const Icon(
          Icons.wc,
          size: 18,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _Kitchen extends StatelessWidget {
  const _Kitchen({
    required this.x,
    required this.y,
  });

  final double x;
  final double y;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x,
      top: y,
      child: CircleAvatar(
        backgroundColor: AttaColors.accent,
        maxRadius: 16,
        child: const Icon(
          Icons.restaurant_rounded,
          size: 18,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _Door extends StatelessWidget {
  const _Door({
    required this.x,
    required this.y,
    required this.size,
    required this.isVertical,
  });

  final double x;
  final double y;
  final double size;
  final bool isVertical;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x,
      top: y,
      child: Container(
        height: isVertical ? size : 2,
        width: isVertical ? 2 : size,
        color: AttaColors.accent,
        padding: EdgeInsets.symmetric(
          vertical: isVertical ? 0 : 2,
          horizontal: isVertical ? 2 : 0,
        ),
        child: Icon(
          Icons.door_sliding_outlined,
          size: 20,
          color: AttaColors.accent,
        ),
      ),
    );
  }
}

class _Table extends StatelessWidget {
  const _Table({
    required this.table,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.isSelected,
    required this.isEnable,
  });

  final AttaTable table;
  final double x;
  final double y;

  final double width;
  final double height;

  final bool isSelected;
  final bool isEnable;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x,
      top: y,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: AttaAnimation.fastAnimation,
            curve: Curves.easeInOut,
            height: height,
            width: width,
            decoration: BoxDecoration(
              color: isEnable
                  ? isSelected
                      ? AttaColors.accent
                      : AttaColors.black
                  : AttaColors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(AttaRadius.small),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: AttaSpacing.xxs),
                    Icon(
                      Icons.person,
                      size: 12,
                      color: AttaColors.white,
                    ),
                    const SizedBox(width: AttaSpacing.xxs),
                    Text(
                      table.numberOfSeats.toString(),
                      textAlign: TextAlign.center,
                      style: AttaTextStyle.content.copyWith(
                        color: AttaColors.white,
                      ),
                    ),
                    const SizedBox(width: AttaSpacing.xxs),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: FractionalTranslation(
              translation: const Offset(0.75, 0.75),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AttaSpacing.xxs,
                  vertical: AttaSpacing.xxxs,
                ),
                decoration: BoxDecoration(
                  color: AttaColors.primary.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(AttaRadius.small),
                ),
                child: Text(
                  '#${table.id}',
                  textAlign: TextAlign.center,
                  style: AttaTextStyle.content.copyWith(
                    color: AttaColors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

double _calculateMaxTableXPosition(List<AttaTable> tables) {
  double max = 0;
  for (final table in tables) {
    if (table.x + table.width > max) {
      max = table.x + table.width;
    }
  }
  return max + 1; // + 1 for right margin
}

double _calculateMaxTableYPosition(List<AttaTable> tables) {
  double max = 0;
  for (final table in tables) {
    if (table.y + table.height > max) {
      max = table.y + table.height;
    }
  }
  return max + 1; // + 1 for bottom margin
}
