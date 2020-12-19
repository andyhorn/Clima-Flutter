import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:clima/services/weather.dart';
import 'package:clima/utilities/constants.dart';
import 'package:clima/utilities/converters.dart' as converters;
import 'package:clima/utilities/constants.dart';

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
  int _tempUnitIndex = 0;
  String _icon;
  String _message;
  String _tempUnit;
  bool _isLoading = false;

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
      _tempUnitIndex = kTempUnits.indexOf('F');
      _tempK = temperature;
      _tempC = tempC.round();
      _tempF = tempF.round();
      _icon = _weatherModel.getWeatherIcon(conditionId);
      _message = '$weatherMessage in $cityName';
      _tempUnit = kTempUnits[_tempUnitIndex];
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
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      final dynamic weatherData =
                          await _weatherModel.getLocationWeather();
                      updateWeatherData(weatherData);
                      setState(() {
                        _isLoading = false;
                      });
                    },
                    child: _isLoading
                        ? SpinKitRipple(
                            color: Colors.white,
                            size: 50.0,
                          )
                        : Icon(
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      textBaseline: TextBaseline.alphabetic,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      children: [
                        Text(
                          _tempUnit == 'K'
                              ? _tempK.toString()
                              : _tempUnit == 'C'
                                  ? _tempC.toString()
                                  : _tempF.toString(),
                          style: kTempTextStyle,
                        ),
                        Text(
                          '°',
                          style: kTempTextStyle,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _tempUnitIndex =
                                  _tempUnitIndex == kTempUnits.length - 1
                                      ? _tempUnitIndex = 0
                                      : _tempUnitIndex + 1;
                              _tempUnit = kTempUnits[_tempUnitIndex];
                            });
                          },
                          child: Text(
                            _tempUnit,
                            style: kTempTextStyle.copyWith(
                              fontSize: 50.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Center(
                      child: Text(
                        _icon,
                        style: kConditionTextStyle,
                      ),
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
