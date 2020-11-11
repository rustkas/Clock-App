import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class ClockView extends StatefulWidget {
  @override
  _ClockViewState createState() => _ClockViewState();
}

class _ClockViewState extends State<ClockView> {
  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      child: Transform.rotate(
        angle: -pi / 2,
        child: CustomPaint(
          painter: ClockPainter(),
        ),
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  var dateTime = DateTime.now();

  // 60 seconds = 360 degrees
  // 1 second = 6 degree

  @override
  void paint(Canvas canvas, Size size) {
    // calculate center point
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // create point
    final center = Offset(centerX, centerY);

    //start painting

    final radius = min(centerX, centerY);

    // draw circle
    {
      final fillBrush = Paint()..color = Color(0xFF444974);
      canvas.drawCircle(center, radius - 40, fillBrush);
    }

    // draw outline
    {
      final outlineBrush = Paint()
        ..color = Color(0xFFEAECFF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 16;
      canvas.drawCircle(center, radius - 40, outlineBrush);
    }

    // clock hand brushes

    //hours
    {
      final hourHandBrush = Paint()
        ..shader =
            RadialGradient(colors: [Color(0xFFEA74AB), Color(0xFFC279FB)])
                .createShader(Rect.fromCircle(center: center, radius: radius))
        ..color = Colors.orange[300]
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 16;

      final degree = (dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180;
      final hourHandX = centerX + 60 * cos(degree);
      final hourHandY = centerY + 60 * sin(degree);

      canvas.drawLine(center, Offset(hourHandX, hourHandY), hourHandBrush);
    }

    //minutes
    {
      final minHandBrush = Paint()
        ..shader =
            RadialGradient(colors: [Color(0xFF748EF6), Color(0xFF77DDFF)])
                .createShader(Rect.fromCircle(center: center, radius: radius))
        ..color = Colors.orange[300]
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 16;

      final degree = dateTime.minute * 6 * pi / 180;
      final minHandX = centerX + 80 * cos(degree);
      final minHandY = centerY + 80 * sin(degree);

      canvas.drawLine(center, Offset(minHandX, minHandY), minHandBrush);
    }

    //seconds
    {
      final secHandBrush = Paint()
        ..shader = RadialGradient(colors: [Colors.lightBlue, Colors.pink])
            .createShader(Rect.fromCircle(center: center, radius: radius))
        ..color = Colors.orange[300]
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 8;

      final degree = dateTime.second * 6 * pi / 180;
      final secHandX = centerX + 80 * cos(degree);
      final secHandY = centerY + 80 * sin(degree);

      canvas.drawLine(center, Offset(secHandX, secHandY), secHandBrush);
    }

    // draw center dot
    {
      final centerFillBrush = Paint()..color = Color(0xFFEAECFF);
      canvas.drawCircle(center, 12, centerFillBrush);
    }

    // decorate a clock
    {
      final dashBrush = Paint()
        ..color = Color(0xFFEAECFF)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 1;

      var outerCircleRadius = radius;
      var innerCircleRadius = radius - 14;
      for (double i = 0; i < 360; i += 12) {
        final degree = i * pi / 180;
        final x1 = centerX + outerCircleRadius * cos(degree);
        final y1 = centerX + outerCircleRadius * sin(degree);

        final x2 = centerX + innerCircleRadius * cos(degree);
        final y2 = centerX + innerCircleRadius * sin(degree);
        canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashBrush);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
