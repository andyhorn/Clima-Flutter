import 'package:geolocator/geolocator.dart';

class Location {
  Future<Position> getLocation() async {
    final doesHavePermission = await hasPermission();
    if (!doesHavePermission) {
      return null;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.lowest,
        forceAndroidLocationManager: true,
        timeLimit: Duration(seconds: 15)
      );

      return position;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> hasPermission() async {
    final currentPermission = await Geolocator.checkPermission();

    if (_hasPermission(currentPermission))
      return true;

    final requestedPermission = await Geolocator.requestPermission();

    return _hasPermission(requestedPermission);
  }

  static bool _hasPermission(LocationPermission permission) {
    return permission == LocationPermission.always ||
      permission == LocationPermission.whileInUse;
  }
}