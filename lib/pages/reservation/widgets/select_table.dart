part of '../reservation_page.dart';

class _ContainerSelectTable extends StatelessWidget {
  const _ContainerSelectTable({
    required this.tables,
    required this.selectedTableId,
    required this.onTableSelected,
    required this.numberOfSeats,
  });

  final List<AttaTable> tables;
  final String? selectedTableId;
  final void Function(String? tableId) onTableSelected;
  final int numberOfSeats;

  @override
  Widget build(BuildContext context) {
    final maxTableXPosition = _calculateMaxTableXPosition(tables);
    final maxTableYPosition = _calculateMaxTableYPosition(tables);

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AttaColors.white,
            borderRadius: BorderRadius.circular(AttaRadius.small),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) => _SelectTable(
              tables: tables,
              selectedTableId: selectedTableId,
              onTableSelected: onTableSelected,
              numberOfSeats: numberOfSeats,
              constraints: constraints,
              maxTableXPosition: maxTableXPosition,
              maxTableYPosition: maxTableYPosition,
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
    required this.tables,
    required this.selectedTableId,
    required this.onTableSelected,
    required this.numberOfSeats,
    required this.constraints,
    required this.maxTableXPosition,
    required this.maxTableYPosition,
  });

  final List<AttaTable> tables;
  final String? selectedTableId;
  final void Function(String? tableId) onTableSelected;
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

  bool isSelectableTable(AttaTable table) {
    final tableNumberOfSeats = table.numberOfSeats;
    // Permet d'éviter de reserver une table avec plus de places que nécessaire (ou trop peu de place)
    return widget.numberOfSeats >= tableNumberOfSeats - 1 && widget.numberOfSeats <= tableNumberOfSeats;
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = widget.constraints.maxHeight;
    final maxWidth = widget.constraints.maxWidth;

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
        final table = widget.tables.firstWhereOrNull(
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
          children: widget.tables
              .map(
                (t) => _Table(
                  table: t,
                  x: (t.x * maxWidth) / widget.maxTableXPosition,
                  y: (t.y * maxHeight) / widget.maxTableYPosition,
                  width: (t.width * maxWidth) / widget.maxTableXPosition,
                  height: (t.height * maxHeight) / widget.maxTableYPosition,
                  isSelected: t.id == widget.selectedTableId,
                  isEnable: isSelectableTable(t),
                ),
              )
              .toList(),
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
                    style: AttaTextStyle.content.copyWith(color: AttaColors.white),
                  ),
                  const SizedBox(width: AttaSpacing.xxs),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: -6,
            right: -6,
            child: FractionalTranslation(
              translation: const Offset(0.5, 0.5),
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
      max = (table.x + table.width).toDouble();
    }
  }
  return max + 1; // + 1 for right margin
}

double _calculateMaxTableYPosition(List<AttaTable> tables) {
  double max = 0;
  for (final table in tables) {
    if (table.y + table.height > max) {
      max = (table.y + table.height).toDouble();
    }
  }
  return max + 1; // + 1 for bottom margin
}
