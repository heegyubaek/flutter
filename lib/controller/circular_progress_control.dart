import 'package:flutter/material.dart';

class CircularProgressWidget extends StatefulWidget {
  @override
  State<CircularProgressWidget> createState() => _CircularProgressWidget();
}

class _CircularProgressWidget extends State<CircularProgressWidget>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Color?> _colorTween;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addListener(() {
        setState(() {});
      });

    _colorTween =
        controller.drive(ColorTween(begin: Colors.yellow, end: Colors.blue));
    controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 300,
          height: 300,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                strokeWidth: 10,
                value: controller.value,
                valueColor: _colorTween,
              ),
              Center(
                child: Text(
                  (controller.value * 100).toInt().toString(),
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
