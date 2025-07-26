import 'package:flutter/material.dart';

class NotConnected extends StatelessWidget {
  const NotConnected({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bluetooth_disabled,
            size: 100,
            color: Colors.red,
          ),
          Text(
            "Turned off",
            style: TextStyle(fontSize: 20),
          ),
          Text("Please turn on bluetooth and try again"),
        ],
      ),
    );
  }
}
