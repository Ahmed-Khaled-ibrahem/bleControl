import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibratormotorcontrol/app_cubit/app_cubit.dart';
import 'package:vibratormotorcontrol/get_it/get_it.dart';
import 'package:vibratormotorcontrol/view/ble_page.dart';
import 'app_bar.dart';
import 'bottm_bar.dart';
import 'not_connected.dart';

class BluetoothControlPage extends StatefulWidget {
  const BluetoothControlPage({super.key});

  @override
  State<BluetoothControlPage> createState() => _BluetoothControlPageState();
}

class _BluetoothControlPageState extends State<BluetoothControlPage> with SingleTickerProviderStateMixin{

  @override
  void initState() {
    super.initState();
    var cubit = getIt<AppCubit>();
    cubit.animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )
      ..repeat(reverse: true);
    cubit.rotationAnimation = Tween<double>(begin: -0.2, end: 0.2).animate(
      CurvedAnimation(parent: cubit.animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    var cubit = getIt<AppCubit>();
    cubit.animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      bottomNavigationBar: const BottomBar(),
      body: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          var cubit = getIt<AppCubit>();

          return Builder(builder: (context) {
            if (!cubit.isConnected) {
              return const NotConnected();
            }
            return const BlePage();
          });
        },
      ),
    );
  }






}
