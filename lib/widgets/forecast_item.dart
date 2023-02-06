import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weatherapp/models/weather_data.dart';

class ForecastItem extends StatelessWidget {
  const ForecastItem({super.key, required this.weatherData});

  final WeatherData weatherData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          DateFormat("E").format(
            DateTime.fromMillisecondsSinceEpoch(
              weatherData.unixTime * 1000,
            ),
          ),
        ),
        Icon(weatherData.icon),
        const SizedBox(height: 10),
        Text(
          "${weatherData.maxTemperature} °C",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          "${weatherData.minTemperature} °C",
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
