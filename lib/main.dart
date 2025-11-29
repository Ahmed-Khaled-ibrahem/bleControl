import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_cubit/app_cubit.dart';
import 'get_it/get_it.dart';
import 'view/layout.dart';

void main() {
  getItSetup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BLE Control',
      scaffoldMessengerKey: scaffoldMessengerKey,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0E21),
        primaryColor: const Color(0xFF00D4FF),
        sliderTheme: SliderThemeData(
          trackHeight: 9,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0),
          activeTrackColor: const Color(0xFFFF0000).withOpacity(0.5),
          inactiveTrackColor: const Color(0xFFFFFFFF),
          thumbColor: const Color(0xFFB20754),
          overlayColor: const Color(0x29FF0000),
          // activeTickMarkColor: Colors.white,
          minThumbSeparation: 100,
          valueIndicatorColor: Colors.white,
          rangeThumbShape: const RoundRangeSliderThumbShape(
              enabledThumbRadius: 5),
        ),
      ),
      home: BlocProvider(
        create: (context) => getIt<AppCubit>()..init(),
        child: const BluetoothControlPage(),
      ),
    );
  }
}

