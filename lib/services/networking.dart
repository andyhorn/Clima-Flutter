import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../utilities/constants.dart' as constants;

class NetworkHelper {
  Future<dynamic> getLocationData(double latitude, double longitude) async {
    final String apiKey = DotEnv().env['OPEN_WEATHER_API_KEY'];
    final String uri = "${constants.kApiBaseUri}?lat=$latitude&lon=$longitude&appid=$apiKey";

    final http.Response response = await http.get(uri);

    if (response.statusCode != 200) {
      print('unable to retrieve weather data.');
      return null;
    }

    final dynamic weatherData = convert.jsonDecode(response.body);

    return weatherData;
  }
}