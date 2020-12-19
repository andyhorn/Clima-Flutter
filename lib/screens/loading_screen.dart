import 'package:clima/screens/location_screen.dart';
import 'package:clima/services/networking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../services/location.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final NetworkHelper networkHelper = NetworkHelper();
  double _latitude;
  double _longitude;

  Future getLocationData() async {
    print('requesting location...');
    final service = Location();

    if (await service.getLocation()) {
      print('location acquired');
      print('latitude: ${service.latitude}');
      print('longitude: ${service.longitude}');

      _latitude = service.latitude;
      _longitude = service.longitude;

      final dynamic weatherData = await networkHelper.getLocationData(_latitude, _longitude);

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return LocationScreen(locationWeather: weatherData,);
      }));
    } else {
      print('could not acquire location.');
    }
  }

  @override
  void initState()  {
    super.initState();
    getLocationData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitRipple(
              color: Colors.white,
              size: 75.0,
            ),
            Text("retrieving local weather data..."),
          ]
        )
      )
    );
  }
}
