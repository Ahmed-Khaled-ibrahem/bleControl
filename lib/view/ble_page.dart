import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibratormotorcontrol/app_cubit/app_cubit.dart';
import 'package:vibratormotorcontrol/view/sliders.dart';
import 'package:vibratormotorcontrol/view/time.dart';
import '../get_it/get_it.dart';
import '../model/session_model.dart';

class BlePage extends StatelessWidget {
  const BlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        var cubit = getIt<AppCubit>();

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF0A0E21),
                const Color(0xFF1D1E33).withOpacity(0.9),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
            children: [
              AnimatedBuilder(
                animation: cubit.animationController,
                builder: (context, child) {
                  return Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.black.withOpacity(0.8),
                            Colors.black.withOpacity(0.1),
                            Colors.blue.withOpacity(0.05),
                            Colors.red.withOpacity(0.5),
                          ],
                          stops: [
                            0.0,
                            cubit.animationController.value,
                            cubit.animationController.value + 0.2,
                            1.0,
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                  child: Container(
                    color: Colors
                        .transparent, // important to be transparent
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  const Color(0xFF00D4FF).withOpacity(0.3),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            left: 0,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 800),
                              switchInCurve: Curves.easeInCirc,
                              switchOutCurve: Curves.easeIn,
                              transitionBuilder:
                                  (Widget child,
                                  Animation<double> animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                              child: Builder(
                                  key: ValueKey(cubit.currentState),
                                  builder: (context) {
                                    if (cubit.sessionTimer == null ||
                                        cubit.sessionTimer!.currentState == SessionTimer.ready || cubit.sessionTimer!.currentState == SessionTimer.completed) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 29, vertical: 0),
                                        child: Column(children: [
                                          Text('Ready',
                                              style: TextStyle(
                                                fontSize: 80,
                                                height: 1,
                                                fontWeight: FontWeight.w900,
                                                color: Colors.blue
                                                    .withOpacity(0.6),
                                              )),
                                        ]),
                                      );
                                    }
                                    if (cubit.sessionTimer!.currentState == SessionTimer.inBreak) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 29, vertical: 0),
                                        child: Column(children: [
                                          Text('Break!',
                                              style: TextStyle(
                                                fontSize: 80,
                                                height: 1,
                                                fontWeight: FontWeight.w900,
                                                color: Colors.white
                                                    .withOpacity(0.6),
                                              )),
                                        ]),
                                      );
                                    }
                                    if (cubit.sessionTimer!.currentState == SessionTimer.inSession) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 0),
                                        child: Column(children: [
                                          Text('Active \nSession',
                                              style: TextStyle(
                                                fontSize: 65,
                                                height: 0.7,
                                                fontWeight: FontWeight.w900,
                                                color: Colors.greenAccent
                                                    .withOpacity(0.6),
                                              )),
                                        ]),
                                      );
                                    }
                                    return Container();
                                  }),
                            ),
                          ),
                          AnimatedBuilder(
                            animation: cubit.animationController,
                            builder: (context, child) {
                              return Transform(
                                transform: Matrix4.identity()
                                  ..setEntry(3, 2, 0.0001) // Perspective
                                  ..rotateY(cubit.rotationAnimation
                                      .value) // Y-axis rotation
                                  ..scale(2.1 +
                                      (cubit.rotationAnimation.value.abs() *
                                          0.3)),
                                // Scale effect
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 85, bottom: 50),
                                  child: Image.asset(
                                    'assets/img.png',
                                    width: 400,
                                    height: 200,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const Sliders(),
                    const TimeShow()
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
