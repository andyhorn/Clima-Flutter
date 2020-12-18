import 'package:flutter/material.dart';
import '../services/location.dart';
import 'package:http/http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

const String kApiBaseUrl = "http://api.openweathermap.org/data/2.5/weather";

String makeUrl(double latitude, double longitude) {
  final apiKey = DotEnv().env['OPEN_WEATHER_API_KEY'];
  print('using key: $apiKey');

  if (apiKey == null)
    return null;

  return "$kApiBaseUrl?lat=$latitude&lon=$longitude&appid=$apiKey";
}

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  double _latitude;
  double _longitude;

  Future getLocation() async {
    print('requesting location...');
    final service = Location();

    if (await service.getLocation()) {
      print('location acquired');
      print('latitude: ${service.latitude}');
      print('longitude: ${service.longitude}');

      setState(() {
        _latitude = service.latitude;
        _longitude = service.longitude;
      });
    } else {
      print('could not acquire location.');
    }
  }

  Future getWeatherData() async {
    final url = makeUrl(_latitude, _longitude);
    final data = await get(url);

    print(data);
  }

  @override
  void initState()  {
    super.initState();

    getLocation().then((erg) {
      getWeatherData();
    });
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
