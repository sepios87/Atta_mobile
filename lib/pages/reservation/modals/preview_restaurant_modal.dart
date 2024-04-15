part of '../reservation_page.dart';

Future<void> _showPreviewRestaurantModal(BuildContext context) async {
  return showDialog(
    context: context,
    useSafeArea: false,
    builder: (childContext) {
      final padding = MediaQuery.of(childContext).padding;

      return Stack(
        clipBehavior: Clip.none,
        children: [
          Panorama(
            sensitivity: 2,
            child: Image.asset('assets/360.jpg'),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.center,
                    colors: [
                      AttaColors.black.withOpacity(0.6),
                      AttaColors.black.withOpacity(0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: padding.top + 4,
            right: padding.right + 4,
            child: IconButton(
              icon: Icon(Icons.close, color: AttaColors.white),
              onPressed: () => Navigator.of(childContext).pop(),
            ),
          ),
        ],
      );
    },
  );
}
