import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:weatherapp/models/weather_data.dart';
import 'package:weatherapp/models/one_call_weather_data.dart';
import 'package:weatherapp/providers.dart';
import 'package:intl/intl.dart';
import 'package:weatherapp/widgets/forecast_item.dart';
import 'package:weatherapp/widgets/temperature_chart.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<void> clearCity(WidgetRef ref) async {
    ref.read(cityProvider.notifier).update((state) => null);
    await ref.read(sharedPrefsProvider).value!.remove("city");
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WillPopScope(
      onWillPop: () async {
        await clearCity(ref);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Weather in ${ref.watch(cityProvider)}"),
          actions: [
            IconButton(
              onPressed: () async => await clearCity(ref),
              icon: const Icon(Icons.clear),
            ),
          ],
        ),
        body: FutureBuilder<OneCallWeatherData>(
          future: ref.watch(apiProvider).getOneCallWeatherData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final WeatherData currentWeatherData =
                  snapshot.data!.currentWeatherData;
              final List<WeatherData> forecastData =
                  snapshot.data!.forecastData;

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  currentWeatherData.icon,
                                  size: 50,
                                ),
                                Text(
                                  "${currentWeatherData.temperature} °C",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 50,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(WeatherIcons.humidity, size: 14),
                                Text("  ${currentWeatherData.humidity} %"),
                                const Spacer(),
                                Text(" ${currentWeatherData.pressure} hPa "),
                                const Icon(WeatherIcons.barometer, size: 14),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(WeatherIcons.sunrise, size: 14),
                                Text(
                                  "  ${DateFormat.Hm().format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                      currentWeatherData.sunrise * 1000,
                                      isUtc: true,
                                    ),
                                  )}",
                                ),
                                const Spacer(),
                                Text(
                                  "${DateFormat.Hm().format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                      currentWeatherData.sunset * 1000,
                                      isUtc: true,
                                    ),
                                  )} ",
                                ),
                                const Icon(WeatherIcons.sunset, size: 14),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children:
                            _forecastRowChildren(forecastData.sublist(1, 6)),
                      ),
                      const SizedBox(height: 20),
                      TemperatureChart(
                        weatherData: forecastData.sublist(1, 6),
                      ),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  List<Widget> _forecastRowChildren(List<WeatherData> forecastData) {
    List<Widget> result = [];

    for (var i = 0; i < forecastData.length; i++) {
      final WeatherData weatherData = forecastData[i];

      if (i != 0) {
        result.add(
          const SizedBox(
            height: 100,
            child: VerticalDivider(),
          ),
        );
      }

      result.add(ForecastItem(weatherData: weatherData));
    }

    return result;
  }
}
