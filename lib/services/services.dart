import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weatherapp/models/weather_services.dart';

class WeatherServices {
  fetchWeather(String city) async {
    var url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=${city}&appid=f5783e1fee68d6228723ecc46804ee40");
    final response = await http.get(url);
    // now we can cange latitude and longitude and let's see how it perfrom.
    try {
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        print(response.body);
        return WeatherData.fromJson(json);
      } else {
        throw Exception('Failed to load Weather data');
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
// replace the api key with your api key thay openWeathemap provide you
// for your current location provide the longitude and latitude of your current location