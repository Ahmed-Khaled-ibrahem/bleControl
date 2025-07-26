import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibratormotorcontrol/app_cubit/app_cubit.dart';
import 'package:vibratormotorcontrol/get_it/get_it.dart';

AppBar myAppBar() {
  return AppBar(
    elevation: 0,
    backgroundColor: const Color(0xFF1D1E33).withOpacity(0),
    title: const Text(
      'BLE Control',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Color(0xFF00D4FF),
      ),
    ),
    actions: [
      BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          var cubit = getIt<AppCubit>();

          return InkWell(
            onTap: cubit.startScanBtnClick,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Builder(builder: (context) {
                if (!cubit.isConnected) {
                  return Container();
                }
                if (cubit.isScanning) {
                  return const Row(
                    children: [
                      Icon(
                        Icons.wifi,
                        color: Colors.blue,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Connecting ...',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  );
                }
                if (cubit.connectedDevice == null) {
                  return const Row(
                    children: [
                      Icon(
                        Icons.bluetooth_disabled,
                        color: Colors.redAccent,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Disconnected',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  );
                }
                return const Row(
                  children: [
                    Icon(
                      Icons.bluetooth_connected,
                      color: Colors.greenAccent,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Connected',
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                );
              }),
            ),
          );
        },
      ),
    ],
  );
}