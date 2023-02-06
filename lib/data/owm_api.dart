import 'dart:convert';

import 'package:weatherapp/models/latlon.dart';
import 'package:http/http.dart' as http;
import 'package:weatherapp/models/one_call_weather_data.dart';

class OpenWeatherMapApi {
  static const String baseUrl = "https://api.openweathermap.org";
  static const String _apiKey = "2a8d2c933f66b27d3165acd06eafa44f";

  final String cityName;

  OpenWeatherMapApi(this.cityName);

  Future<LatLon> getCoordinates({limit = 1}) async {
    final url = Uri.parse(
        "$baseUrl/geo/1.0/direct?q=$cityName&limit=$limit&appid=$_apiKey");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      if (response.body == "[]") {
        throw Exception("City not found");
      }

      return LatLon.fromJson(json[0]);
    } else if (response.statusCode == 404) {
      throw Exception("City not found");
    } else {
      throw Exception("Could not get coordinates");
    }
  }

  Future<OneCallWeatherData> getOneCallWeatherData({
    exclude = "minutely,hourly,alerts",
  }) async {
    late final LatLon coordinates;
    try {
      coordinates = await getCoordinates();
    } catch (e) {
      rethrow;
    }

    final url = Uri.parse(
        "$baseUrl/data/3.0/onecall?lat=${coordinates.lat}&lon=${coordinates.lon}&exclude=$exclude&units=metric&appid=$_apiKey");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return OneCallWeatherData.fromJson(json);
    } else if (response.statusCode == 404) {
      throw Exception("City not found");
    } else {
      throw Exception("Could not get weather data");
    }
  }

  // Future<WeatherData> getCurrentWeatherData() async {
  //   final url = Uri.parse(
  //       "$baseUrl/data/2.5/weather?q=$cityName&units=metric&appid=$_apiKey");
  //   final response = await http.get(url);

  //   if (response.statusCode == 200) {
  //     final json = jsonDecode(response.body);
  //     return WeatherData.fromJson(json);
  //   } else if (response.statusCode == 404) {
  //     throw Exception("City not found");
  //   } else {
  //     throw Exception("Could not get weather data");
  //   }
  // }

  // Future<List<WeatherData>> getForecastData({int dayCount = 5}) async {
  //   final url = Uri.parse(
  //       "$baseUrl/data/2.5/forecast?q=$cityName&units=metric&appid=$_apiKey");
  //   final response = await http.get(url);

  //   if (response.statusCode == 200) {
  //     final json = jsonDecode(response.body);
  //     return (json["list"] as List)
  //         .map((e) => WeatherData.fromJson(e))
  //         .toList();
  //   } else if (response.statusCode == 404) {
  //     throw Exception("City not found");
  //   } else {
  //     throw Exception("Could not get weather data");
  //   }
  // }
}
