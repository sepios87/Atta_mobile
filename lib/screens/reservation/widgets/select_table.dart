part of '../reservation_screen.dart';

class _SelectTable extends StatefulWidget {
  const _SelectTable({
    required this.tables,
    required this.selectedTableId,
    required this.onTableSelected,
  });

  final List<AttaTable> tables;
  final String? selectedTableId;
  final void Function(String tableId) onTableSelected;

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
    final maxTableXPosition = _calculateMaxTableXPosition(widget.tables);
    final maxTableYPosition = _calculateMaxTableYPosition(widget.tables);

    return Container(
      decoration: BoxDecoration(
        color: AttaColors.white,
        borderRadius: BorderRadius.circular(AttaRadius.small),
      ),
      child: LayoutBuilder(
        builder: (context, ctr) {
          return GestureDetector(
            onTapDown: (details) {
              final position = _transformationController.toScene(details.localPosition);
              final table = widget.tables.firstWhereOrNull(
                (e) {
                  final tablePosition = Offset(
                    (e.x * ctr.maxWidth) / maxTableXPosition,
                    (e.y * ctr.maxHeight) / maxTableYPosition,
                  );
                  final tableSize = Size(
                    (e.width * ctr.maxWidth) / maxTableXPosition,
                    (e.height * ctr.maxHeight) / maxTableYPosition,
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
              if (table != null) {
                widget.onTableSelected(table.id);
              }
            },
            child: InteractiveViewer(
              transformationController: _transformationController,
              boundaryMargin: const EdgeInsets.only(
                right: 32,
                bottom: 32,
                top: 16,
                left: 16,
              ), // For padding number of seats widget
              maxScale: 3,
              child: Stack(
                clipBehavior: Clip.none,
                children: widget.tables
                    .map(
                      (e) => _Table(
                        table: e,
                        x: (e.x * ctr.maxWidth) / maxTableXPosition,
                        y: (e.y * ctr.maxHeight) / maxTableYPosition,
                        width: (e.width * ctr.maxWidth) / maxTableXPosition,
                        height: (e.height * ctr.maxHeight) / maxTableYPosition,
                        isSelected: e.id == widget.selectedTableId,
                      ),
                    )
                    .toList(),
              ),
            ),
          );
        },
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
  });

  final AttaTable table;
  final double x;
  final double y;

  final double width;
  final double height;

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x,
      top: y,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            height: height,
            width: width,
            decoration: BoxDecoration(
              color: isSelected ? AttaColors.primaryLight : AttaColors.black,
              borderRadius: BorderRadius.circular(AttaRadius.small),
            ),
            child: Center(
              child: Text(
                table.id,
                textAlign: TextAlign.center,
                style: AttaTextStyle.content.copyWith(color: AttaColors.white),
              ),
            ),
          ),
          Positioned(
            bottom: -6,
            right: -6,
            child: FractionalTranslation(
              translation: const Offset(0.5, 0.5),
              child: Container(
                height: 20,
                decoration: BoxDecoration(
                  color: AttaColors.primaryLight.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(AttaRadius.small),
                ),
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
  return max;
}

double _calculateMaxTableYPosition(List<AttaTable> tables) {
  double max = 0;
  for (final table in tables) {
    if (table.y + table.height > max) {
      max = (table.y + table.height).toDouble();
    }
  }
  return max;
}
