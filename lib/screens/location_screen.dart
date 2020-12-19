import 'package:clima/services/weather.dart';
import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';

double kelvinToCelsius(double kelvin) => kelvin - 273.5;
double kelvinToFahrenheit(double kelvin) => kelvinToCelsius(kelvin) * 1.8 + 32.0;

class LocationScreen extends StatefulWidget {
  final locationWeather;

  LocationScreen({this.locationWeather});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final WeatherModel _weatherModel = WeatherModel();
  int _condition;
  double _temperature;
  String _cityName;
  String _icon;
  String _message;

  @override
  void initState() {
    super.initState();
    print(widget.locationWeather);

    final dynamic weatherData = widget.locationWeather;
    updateWeatherData(weatherData);
  }



  void updateWeatherData(dynamic weatherData) {
    final int conditionId = weatherData['weather'][0]['id'];
    final double temperature = weatherData['main']['temp'];
    final String cityName = weatherData['name'];

    print('condition: $conditionId');
    print('temperature: $temperature');
    print('city name: $cityName');

    setState(() {
      _condition = conditionId;
      _temperature = temperature;
      _cityName = cityName;
      _icon = _weatherModel.getWeatherIcon(conditionId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {},
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {},
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '${kelvinToFahrenheit(_temperature).round().toString()}°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      _weatherModel.getWeatherIcon(_condition),
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  '${_weatherModel.getMessage(kelvinToCelsius(_temperature).toInt())} in $_cityName',
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// 🍦