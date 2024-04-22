import 'dart:isolate';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var total = 0.0;
  var totalValue = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Image.asset('assets/gifs/girl-8331_256.gif'),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  total = await asyncTaskFunction();
                  debugPrint('Result 1: $total');
                  setState(() {});
                },
                child: const Text(' Async Task Button'),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Async Result: $total',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              //Isolate
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // background (button) color
                  foregroundColor: Colors.white, // foreground (text) color
                ),
                onPressed: () async {
                  final receivePort = ReceivePort();
                  await Isolate.spawn(
                      isolateTaskFunction, receivePort.sendPort);
                  receivePort.listen((total) {
                    debugPrint('Result 2: $total');
                    totalValue = total;
                    setState(() {});
                  });
                },
                child: const Text('Isolate Task Button '),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Isolate Result: $totalValue',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<double> asyncTaskFunction() async {
    var total = 0.0;
    for (var i = 0; i < 1000000000; i++) {
      total += i;
    }
    return total;
  }
}

isolateTaskFunction(SendPort sendPort) {
  var total = 0.0;
  for (var i = 0; i < 1000000000; i++) {
    total += i;
  }
  sendPort.send(total);
}
