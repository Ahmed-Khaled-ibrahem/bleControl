import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibratormotorcontrol/app_cubit/app_cubit.dart';
import 'package:vibratormotorcontrol/get_it/get_it.dart';

class Sliders extends StatefulWidget {
  const Sliders({super.key});

  @override
  State<Sliders> createState() => _SlidersState();
}

class _SlidersState extends State<Sliders> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        var cubit = getIt<AppCubit>();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Column(
            children: [
              Slider(
                value: cubit.motor1Speed,
                min: 0,
                max: 255,
                label: cubit.motor1Speed.round().toString(),
                divisions: 254,
                onChanged: (value) {
                  cubit.motor1Speed = value;
                  setState(() {});
                },
                onChangeEnd: (value) => cubit.updateMotorSpeed(1, value),
                activeColor: Color.fromRGBO(cubit.motor1Speed.round(), 10, 80, 1),
              ),
              Slider(
                value: cubit.motor2Speed,
                activeColor: Color.fromRGBO(cubit.motor2Speed.round(), 10, 80, 1),
                label: cubit.motor2Speed.round().toString(),
                min: 0,
                max: 255,
                divisions: 254,
                onChanged: (value) {
                  cubit.motor2Speed = value;
                  setState(() {});
                },
                onChangeEnd: (value) => cubit.updateMotorSpeed(2, value),
              ),
              Slider(
                value: cubit.motor3Speed,
                activeColor: Color.fromRGBO(cubit.motor3Speed.round(), 10, 80, 1),
                min: 0,
                label: cubit.motor3Speed.round().toString(),
                max: 255,
                divisions: 254,
                onChanged: (value) {
                  cubit.motor3Speed = value;
                  setState(() {});
                },
                onChangeEnd: (value) => cubit.updateMotorSpeed(3, value),
              ),
            ],
          ),
        );
      },
    );
  }
}
