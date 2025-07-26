import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibratormotorcontrol/app_cubit/app_cubit.dart';

import '../get_it/get_it.dart';
import '../model/session_model.dart';

class TimeShow extends StatelessWidget {
  const TimeShow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        var cubit = getIt<AppCubit>();

        if(cubit.sessionTimer == null || cubit.sessionTimer!.currentState == SessionTimer.ready || cubit.sessionTimer!.currentState == SessionTimer.completed) {
          return Container();
        }

        return Column(
          children: [
            Text(
              cubit.sessionTimer!.formattedTime.toString(),
              style: const TextStyle(
                  color: Colors.white, fontSize: 40, fontWeight: FontWeight.w900),
            ),
            const Divider(),
            Text(
              'Round ${cubit.sessionTimer!.currentRound}/${cubit.sessionTimer!.totalRounds}',
              style: const TextStyle(
                  color: Colors.white, fontSize: 20, fontWeight: FontWeight.w300),
            ),
          ],
        );
      },
    );
  }
}
