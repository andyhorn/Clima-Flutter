import 'package:geolocator/geolocator.dart';

class Location {
  double latitude = 0.0;
  double longitude = 0.0;

  Future<bool> getLocation() async {
    Position position;

    try {
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.lowest,
        forceAndroidLocationManager: true,
        timeLimit: Duration(seconds: 15)
      );
    } catch (e) {
      print('error acquiring permission:');
      print(e);
    }

    if (position == null) {
      return false;
    }

    this.latitude = position.latitude;
    this.longitude = position.longitude;

    return true;
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