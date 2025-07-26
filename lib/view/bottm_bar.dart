import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibratormotorcontrol/app_cubit/app_cubit.dart';
import 'package:vibratormotorcontrol/get_it/get_it.dart';
import 'package:vibratormotorcontrol/view/dialog.dart';

import '../model/session_model.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        var cubit = getIt<AppCubit>();

        return Builder(builder: (context) {
          bool _showFirst = true;
          if (!cubit.isConnected || cubit.connectedDevice == null) {
            return const SizedBox(
              height: 0,
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 20),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                final flipAnimation =
                Tween(begin: pi, end: 0.0).animate(animation);

                return AnimatedBuilder(
                  animation: flipAnimation,
                  child: child,
                  builder: (context, child) {
                    final isUnder = (ValueKey(_showFirst) != child!.key);
                    var tilt = (animation.value - 0.5).abs() - 0.5;
                    tilt *= isUnder ? -0.003 : 0.003;
                    final value = isUnder
                        ? min(flipAnimation.value, pi / 2)
                        : flipAnimation.value;
                    return Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001) // Perspective
                        ..rotateY(value + tilt),
                      alignment: Alignment.center,
                      child: child,
                    );
                  },
                );
              },
              child: Builder(
                  key: Key(cubit.sessionTimer == null ||
                      cubit.sessionTimer!.currentState ==
                          SessionTimer.inSession
                      ? "closeSession"
                      : "startSession"),
                  builder: (context) {
                    if (cubit.sessionTimer == null ||
                        cubit.sessionTimer!.currentState ==
                            SessionTimer.completed ||
                        cubit.sessionTimer!.currentState ==
                            SessionTimer.ready) {
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shadowColor: Colors.red,
                            elevation: 2,
                          ),
                          onPressed: () {
                            _showConfigurationDialog(context, cubit);
                          },
                          child: const Text(
                            "Start Session",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    }
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shadowColor: Colors.red,
                            elevation: 2,
                          ),
                          onPressed: () {
                            cubit.closeSession();
                          },
                          child: const Text("Close Session",
                              style: TextStyle(
                                color: Colors.white,
                              ))),
                    );
                  }),
            ),
          );
        });
      },
    );
  }

  Future<void> _showConfigurationDialog(BuildContext context,
      AppCubit cubit) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          scrollable: true,
          alignment: Alignment.center,
          contentPadding: const EdgeInsets.all(20),
          title: const Text('Configure Session'),
          content: const DialogBody(),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                cubit.createSession();
                cubit.sessionTimer!.updateConfiguration(
                  roundDuration: cubit.roundDuration,
                  breakDuration: cubit.breakDuration,
                  totalRounds: cubit.totalRounds,
                );
                cubit.startSession();
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }


}
