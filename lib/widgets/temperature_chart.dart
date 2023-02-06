import 'package:flutter/material.dart';
import 'package:weatherapp/models/weather_data.dart';

class TemperatureChart extends StatelessWidget {
  const TemperatureChart({
    super.key,
    required this.weatherData,
    this.height = 100,
  });

  final List<WeatherData> weatherData;
  final double height;

  @override
  Widget build(BuildContext context) {
    double max = weatherData[0].maxTemperature!;
    double min = weatherData[0].maxTemperature!;
    for (var i = 1; i < weatherData.length; i++) {
      if (weatherData[i].maxTemperature! > max) {
        max = weatherData[i].maxTemperature!;
      }
      if (weatherData[i].maxTemperature! < min) {
        min = weatherData[i].maxTemperature!;
      }
    }
    double difference = max - min;

    List<double> Y = List.generate(
      5,
      (int i) => (max - weatherData[i].maxTemperature!) / difference,
    );

    return RepaintBoundary(
      child: CustomPaint(
        size: Size.fromHeight(height),
        painter: ChartPainter(Y: Y, max: max, min: min),
      ),
    );
  }
}

class ChartPainter extends CustomPainter {
  final List<double> X = [0.9 / 10, 3 / 10, 1 / 2, 7.1 / 10, 9.1 / 10];
  final List<double> Y;
  final double max;
  final double min;

  ChartPainter({required this.Y, required this.max, required this.min});

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < Y.length; i++) {
      final Paint paint = Paint()..color = Colors.black;
      final Offset offset = Offset(size.width * X[i], size.height * Y[i]);

      canvas.drawCircle(offset, 2, paint);

      if (i != 0) {
        canvas.drawLine(Offset(size.width * X[i - 1], size.height * Y[i - 1]),
            offset, paint);
      }
    }

    Y.sort();
    dwawText(
      text: max.toStringAsFixed(1),
      canvas: canvas,
      position: const Offset(0, -8),
    );
    dwawText(
      text: (min + ((max - min) / 2)).toStringAsFixed(1),
      canvas: canvas,
      position: Offset(0, (size.height / 2) - 8),
    );
    dwawText(
      text: min.toStringAsFixed(1),
      canvas: canvas,
      position: Offset(0, size.height - 8),
    );
  }

  dwawText({String? text, required Canvas canvas, Offset? position}) {
    final textSpan = TextSpan(
      text: text,
      style: const TextStyle(color: Colors.black),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(minWidth: 0, maxWidth: 30);
    textPainter.paint(canvas, position ?? Offset.zero);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
