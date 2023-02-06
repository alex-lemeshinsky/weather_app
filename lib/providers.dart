import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherapp/data/owm_api.dart';

final sharedPrefsProvider = FutureProvider<SharedPreferences>(
  (ref) async => await SharedPreferences.getInstance(),
);

final cityProvider = StateProvider<String?>(
  (ref) => ref.watch(sharedPrefsProvider).maybeWhen(
        data: (prefs) => prefs.getString("city"),
        orElse: () => null,
      ),
);

final apiProvider = Provider<OpenWeatherMapApi>(
  (ref) => OpenWeatherMapApi(ref.watch(cityProvider) ?? ""),
);
