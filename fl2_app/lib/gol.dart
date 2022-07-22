import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:fl2_app/golcalc.dart';
import 'package:flutter/material.dart';

class Gol extends StatefulWidget {
  const Gol({Key? key}) : super(key: key);

  @override
  State<Gol> createState() => _GolState();
}

class _GolState extends State<Gol> {
  static const int _size = 100;
  int _zoom = 1;

  late GolCalculator _calc;

  _GolState() {
    _initGolCalculator();

    Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() {
          _calc.step();
        });
      },
    );
  }

  void _initGolCalculator() {
    var rnd = Random();
    var startCfg = List<List<int>>.empty(growable: true);
    for (int i = 0; i < _size * _size / 5; i++) {
      startCfg.add([rnd.nextInt(_size), rnd.nextInt(_size)]);
    }
    _calc = GolCalculator(_size, startCfg);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Gol"),
          actions: [
            IconButton(
              icon: const Icon(Icons.start),
              onPressed: () {
                _initGolCalculator();
              },
            ),
          ],
        ),
        body: Column(children: [
          Slider(
            min: 1,
            max: 4,
            value: _zoom.toDouble(),
            onChanged: (d) {
              setState(() {
                _zoom = d.toInt();
              });
            },
          ),
          SingleChildScrollView(
              child: Container(
            color: Colors.grey[100],
            width: _size.toDouble() * _zoom,
            height: _size.toDouble() * _zoom,
            child: CustomPaint(painter: _GolPainter(_calc, _zoom)),
          )),
        ]));
  }
}

class _GolPainter extends CustomPainter {
  final GolCalculator _calc;
  final int _zoom;

  _GolPainter(this._calc, this._zoom);

  @override
  void paint(Canvas canvas, Size size) {
    var p = Paint();
    p.strokeWidth = _zoom.toDouble();
    canvas.drawPoints(PointMode.points, _zoomOffsets(_calc.getOffsets()), p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  List<Offset> _zoomOffsets(List<Offset> offsets) {
    List<Offset> r = [];

    for (var o in offsets) {
      r.add(Offset(o.dx * _zoom, o.dy * _zoom));
    }

    return r;
  }
}
