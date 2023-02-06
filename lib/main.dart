import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherapp/providers.dart';
import 'package:weatherapp/screens/city_input.dart';
import 'package:weatherapp/screens/home.dart';

void main() {
  runApp(const ProviderScope(child: WeatherApp()));
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather app',
      debugShowCheckedModeBanner: false,
      home: Consumer(
        builder: (context, ref, child) {
          if (ref.watch(cityProvider) != null) {
            return const HomeScreen();
          } else {
            return const CityInputScreen();
          }
        },
      ),
    );
  }
}
