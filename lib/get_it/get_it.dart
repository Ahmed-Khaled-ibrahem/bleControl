import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../app_cubit/app_cubit.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();


final getIt = GetIt.I;

void getItSetup() {
  // bloc
  getIt.registerSingleton<AppCubit>(AppCubit());

}
