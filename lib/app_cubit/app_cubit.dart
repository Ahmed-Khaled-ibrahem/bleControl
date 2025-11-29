import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import '../get_it/get_it.dart';
import '../model/session_model.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());

  bool isConnected = false;
  BluetoothDevice? connectedDevice;

  List<BluetoothService> services = [];
  BluetoothCharacteristic? m1Char;
  BluetoothCharacteristic? m2Char;
  BluetoothCharacteristic? m3Char;

  BluetoothCharacteristic? m1Char2;
  BluetoothCharacteristic? m2Char2;
  BluetoothCharacteristic? m3Char2;

  double motor1Speed = 0;
  double motor2Speed = 0;
  double motor3Speed = 0;

  bool isScanning = false;
  String statusMessage = 'Not Connected';

  late AnimationController animationController;
  late Animation<double> rotationAnimation;

  SessionTimer? sessionTimer;
  String currentState = SessionTimer.ready;
  String displayTime = '00:00';
  int currentRound = 0;

  int roundDuration = 30;
  int breakDuration = 2;
  int totalRounds = 2;

  void init() {
    requestPermissions();
    FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
      isConnected = state == BluetoothAdapterState.on;
      print("isConnected: $isConnected");
      refresh();
    });
  }

  void startScanBtnClick() {
    if (connectedDevice == null && !isScanning) {
      startScan();
    }
    refresh();
  }

  void startScan() async {
    isScanning = true;
    refresh();

    var subscription = FlutterBluePlus.onScanResults.listen((results) {
      for (ScanResult r in results) {
        print("result name: $r");
        if (r.device.advName == "right") {
          connectToDevice(r.device);
        }
        if (r.device.advName == "left") {
          connectToDevice(r.device);
        }
      }
    });

    FlutterBluePlus.cancelWhenScanComplete(subscription);
    await FlutterBluePlus.adapterState
        .where((val) => val == BluetoothAdapterState.on)
        .first;

    await FlutterBluePlus.startScan(
        withServices: [Guid("180D")],
        withNames: ["right", "left"],
        timeout: const Duration(seconds: 4));

    await FlutterBluePlus.isScanning.where((val) => val == false).first;

    isScanning = false;
    refresh();
  }

  void connectToDevice(BluetoothDevice device) async {
    await device.connect();

    connectedDevice = device;
    refresh();

    discoverServices(device);

    device.connectionState.listen((state) {
      if (state == BluetoothConnectionState.disconnected) {
        handleDisconnect();
      } else if (state == BluetoothConnectionState.connected) {
        statusMessage = 'Connected';
        refresh();
      }
    });
  }

  void handleDisconnect() {
    connectedDevice = null;
    services = [];
    m1Char = null;
    m2Char = null;
    m3Char = null;
    motor1Speed = 0;
    motor2Speed = 0;
    motor3Speed = 0;
    statusMessage = 'Device Disconnected';

    refresh();
  }

  void discoverServices(BluetoothDevice device) async {
    List<BluetoothService> discoveredServices = await device.discoverServices();
    services = discoveredServices;
    refresh();

    for (BluetoothService service in services) {
      if (service.uuid.toString() == "19b10000-e8f2-537e-4f6c-d104768a1214") {
        for (BluetoothCharacteristic characteristic
            in service.characteristics) {
          switch (characteristic.uuid.toString().toLowerCase()) {
            case "19b10001-e8f2-537e-4f6c-d104768a1214":
              if(device.advName == "right"){
                m1Char = characteristic;
              }
              else{
                m1Char2 = characteristic;
              }
              break;
            case "19b10002-e8f2-537e-4f6c-d104768a1214":
              if(device.advName == "right"){
                m2Char = characteristic;
              }
              else{
                m2Char2 = characteristic;
              }
              break;
            case "19b10003-e8f2-537e-4f6c-d104768a1214":
              if(device.advName == "right"){
                m3Char = characteristic;
              }
              else{
                m3Char2 = characteristic;
              }
              break;
          }
        }
      }
    }
  }

  void refresh() {
    emit(MyState(refreshKey: DateTime.now().millisecondsSinceEpoch));
    print("refreshing..");
  }

  Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.locationWhenInUse,
    ].request();
    statuses.forEach((permission, status) {
      print('$permission: $status');
    });
    String message = statuses.values.every((s) => s.isGranted)
        ? 'All permissions granted'
        : 'Some permissions denied';
    print(message);
  }

  void closeSession() {
    updateMotorSpeed(1, 0);
    updateMotorSpeed(2, 0);
    updateMotorSpeed(3, 0);

    sessionTimer!.dispose();
    sessionTimer = null;
    refresh();
  }

  void createSession() {
    sessionTimer = SessionTimer(
      roundDuration: 30,
      breakDuration: 2,
      totalRounds: 2,
      onStateChanged: (state) {
        currentState = state;
        refresh();
      },
      onTick: (remainingSeconds) {
        displayTime = sessionTimer!.formattedTime;
        refresh();
      },
      onSessionComplete: () {
        updateMotorSpeed(1, 0);
        updateMotorSpeed(2, 0);
        updateMotorSpeed(3, 0);
        scaffoldMessengerKey.currentState?.showSnackBar(
          const SnackBar(content: Text('Session completed!')),
        );
      },
    );
  }

  void startSession() {
    sessionTimer?.startSession();
    updateMotorSpeed(1, motor1Speed);
    updateMotorSpeed(2, motor2Speed);
    updateMotorSpeed(3, motor3Speed);
  }

  void updateMotorSpeed(int motor, double value) async {
    if (sessionTimer == null ||
        sessionTimer!.currentState == SessionTimer.ready ||
        sessionTimer!.currentState == SessionTimer.completed) {
      return;
    }
    try {
      int intValue = value.round();
      List<int> bytes = [intValue];

      switch (motor) {
        case 1:
          if (m1Char != null) await m1Char!.write(bytes);
          if (m1Char2 != null) await m1Char2!.write(bytes);
          motor1Speed = value;
          refresh();
          break;
        case 2:
          if (m2Char != null) await m2Char!.write(bytes);
          if (m2Char2 != null) await m2Char2!.write(bytes);
          motor2Speed = value;
          refresh();
          break;
        case 3:
          if (m3Char != null) await m3Char!.write(bytes);
          if (m3Char2 != null) await m3Char2!.write(bytes);
          motor3Speed = value;
          refresh();
          break;
      }
    } catch (e) {
      scaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(
          content:
              Text('Something went wrong\nYour device might be out of range'),
        ),
      );
    }
  }

  void disconnect() async {
    if (connectedDevice != null) {
      await connectedDevice!.disconnect();
      connectedDevice = null;
      services = [];
      m1Char = null;
      m2Char = null;
      m3Char = null;
      motor1Speed = 0;
      motor2Speed = 0;
      motor3Speed = 0;
      refresh();
    }
  }
}
