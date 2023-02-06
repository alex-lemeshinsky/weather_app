import 'package:weatherapp/models/weather_data.dart';

class OneCallWeatherData {
  final WeatherData currentWeatherData;
  final List<WeatherData> forecastData;

  OneCallWeatherData(
      {required this.currentWeatherData, required this.forecastData});

  factory OneCallWeatherData.fromJson(Map<String, dynamic> json) {
    return OneCallWeatherData(
      currentWeatherData: WeatherData.fromCurrentWeatherJson(json["current"]),
      forecastData: (json["daily"] as List)
          .map((e) => WeatherData.fromDailyForecastJson(e))
          .toList(),
    );
  }
}
