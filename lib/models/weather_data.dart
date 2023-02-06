import 'package:flutter/material.dart';
import 'package:weatherapp/constants.dart';

class WeatherData {
  final int unixTime;
  final double temperature;
  final double? maxTemperature;
  final double? minTemperature;
  final int humidity;
  final int pressure;
  final int sunrise;
  final int sunset;
  final String weatherIconId;

  WeatherData({
    required this.unixTime,
    required this.temperature,
    this.maxTemperature,
    this.minTemperature,
    required this.humidity,
    required this.pressure,
    required this.sunrise,
    required this.sunset,
    required this.weatherIconId,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      unixTime: json["dt"],
      temperature: double.parse((json["main"]["temp"]).toString()),
      maxTemperature: double.parse((json["main"]["temp_max"]).toString()),
      minTemperature: double.parse((json["main"]["temp_min"]).toString()),
      humidity: json["main"]["humidity"],
      pressure: json["main"]["pressure"],
      sunrise: json["sys"]["sunrise"],
      sunset: json["sys"]["sunset"],
      weatherIconId: json["weather"][0]["icon"],
    );
  }

  factory WeatherData.fromCurrentWeatherJson(Map<String, dynamic> json) {
    return WeatherData(
      unixTime: json["dt"],
      temperature: double.parse((json["temp"]).toString()),
      humidity: json["humidity"],
      pressure: json["pressure"],
      sunrise: json["sunrise"],
      sunset: json["sunset"],
      weatherIconId: json["weather"][0]["icon"],
    );
  }

  factory WeatherData.fromDailyForecastJson(Map<String, dynamic> json) {
    return WeatherData(
      unixTime: json["dt"],
      temperature: double.parse((json["temp"]["day"]).toString()),
      maxTemperature: double.parse((json["temp"]["max"]).toString()),
      minTemperature: double.parse((json["temp"]["min"]).toString()),
      humidity: json["humidity"],
      pressure: json["pressure"],
      sunrise: json["sunrise"],
      sunset: json["sunset"],
      weatherIconId: json["weather"][0]["icon"],
    );
  }

  IconData get icon => weatherIcons[weatherIconId] ?? Icons.error_outline;
}
