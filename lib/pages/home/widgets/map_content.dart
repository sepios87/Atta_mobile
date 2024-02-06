part of '../home_page.dart';

class _MapContent extends StatelessWidget {
  const _MapContent({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: MapController(),
      options: const MapOptions(
        // TODO(florian): set current location
        initialCenter: LatLng(43.600000, 1.433333),
      ),
      children: [
        TileLayer(
          urlTemplate:
              'https://tile.jawg.io/a89cf173-9914-47cc-a9d7-5ba3812680e7/{z}/{x}/{y}{r}.png?access-token=${const String.fromEnvironment('JAWG_API_KEY')}',
          userAgentPackageName: 'com.atta.app',
        ),
      ],
    );
  }
}
