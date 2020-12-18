import 'package:geolocator/geolocator.dart';

class Location {
  double latitude = 0.0;
  double longitude = 0.0;

  Future getLocation() async {
    final hasUserPermission = await hasPermission();

    if (!hasUserPermission) {
      return null;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.lowest,
        forceAndroidLocationManager: true,
        timeLimit: Duration(seconds: 15)
      );

      this.latitude = position.latitude;
      this.longitude = position.longitude;
    } catch (e) {
      print('error acquiring permission:');
      print(e);
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