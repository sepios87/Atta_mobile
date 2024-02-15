import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> determinePosition() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return Future.error('Location permissions are denied');
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    final lastPosition = await Geolocator.getLastKnownPosition();
    if (lastPosition != null) return lastPosition;

    return Geolocator.getCurrentPosition();
  }
}
