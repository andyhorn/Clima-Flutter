import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location.dart';
import 'package:http/http.dart';

const String kApiKey = "d59e9664b0bea35133598dc05f12fe10";
const String kApiBaseUrl = "api.openweathermap.org/data/2.5/weather?";

String makeUrl(double latitude, double longitude) {
  return "${kApiBaseUrl}lat=${latitude}&lon=${longitude}&appid=$kApiKey";
}

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Position currentLocation;

  Future getLocation() async {
    print('requesting location...');
    final service = Location();
    final position = await service.getLocation();
    if (position == null) {
      print('could not acquire location.');
    } else {
      print(position);
    }

    setState(() {
      currentLocation = position;
    });
  }

  void getWeatherData() async {
    final url = makeUrl(currentLocation.latitude, currentLocation.latitude);
    final data = await get(url);
  }

  @override
  void initState()  {
    super.initState();

    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          onPressed: () async {
            //Get the current location
          },
          child: Text('Get Location'),
        ),
      ),
    );
  }
}
