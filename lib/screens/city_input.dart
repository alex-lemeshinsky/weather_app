import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherapp/providers.dart';

class CityInputScreen extends ConsumerWidget {
  const CityInputScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController controller = TextEditingController(
      text: ref.read(cityProvider),
    );

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Input city"),
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  ref
                      .read(cityProvider.notifier)
                      .update((state) => controller.text);
                  await ref
                      .read(sharedPrefsProvider)
                      .value!
                      .setString("city", controller.text);
                },
                child: const Text("What's the weather?"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
