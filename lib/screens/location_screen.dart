import 'package:flutter/material.dart';
import 'package:clima/services/weather.dart';
import 'package:clima/utilities/constants.dart';
import 'package:clima/utilities/converters.dart' as converters;

const kTempUnits = ["K", "C", "F"];

class LocationScreen extends StatefulWidget {
  final locationWeather;

  LocationScreen({this.locationWeather});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final WeatherModel _weatherModel = WeatherModel();
  double _tempK;
  int _tempF;
  int _tempC;
  String _icon;
  String _message;
  String _tempUnit;

  @override
  void initState() {
    super.initState();
    final dynamic weatherData = widget.locationWeather;
    updateWeatherData(weatherData);
  }

  void updateWeatherData(dynamic weatherData) {
    final int conditionId = weatherData['weather'][0]['id'];
    final double temperature = weatherData['main']['temp'];
    final String cityName = weatherData['name'];
    final double tempC = converters.kelvinToCelsius(temperature);
    final double tempF = converters.kelvinToFahrenheit(temperature);
    final String weatherMessage = _weatherModel.getMessage(tempC.toInt());

    setState(() {
      _tempK = temperature;
      _tempC = tempC.round();
      _tempF = tempF.round();
      _icon = _weatherModel.getWeatherIcon(conditionId);
      _message = '$weatherMessage in $cityName';
      _tempUnit = "F";
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
                      '$_tempF°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      _icon,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  _message,
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
