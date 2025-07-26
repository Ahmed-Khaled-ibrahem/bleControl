import 'package:flutter/material.dart';
import '../app_cubit/app_cubit.dart';
import '../get_it/get_it.dart';

class DialogBody extends StatefulWidget {
  const DialogBody({super.key});

  @override
  State<DialogBody> createState() => _DialogBodyState();
}

class _DialogBodyState extends State<DialogBody> {
  var cubit = getIt<AppCubit>();


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildNumberPicker(
          title: 'Round Duration (min)',
          value: cubit.roundDuration,
          min: 1,
          max: 60,
          onChanged: (value) {
            cubit.roundDuration = value;
            cubit.refresh();
            setState(() {});
          },
        ),
        _buildNumberPicker(
          title: 'Break Duration (min)',
          value: cubit.breakDuration,
          min: 1,
          max: 30,
          onChanged: (value) {
            cubit.breakDuration = value;
            cubit.refresh();
            setState(() {});
          },
        ),
        _buildNumberPicker(
          title: 'Number of Rounds',
          value: cubit.totalRounds,
          min: 1,
          max: 10,
          onChanged: (value) {
            cubit.totalRounds = value;
            cubit.refresh();
            setState(() {});
          },
        ),
      ],
    );
  }

  Widget _buildNumberPicker({
    required String title,
    required int value,
    required int min,
    required int max,
    required Function(int) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: value > min ? () => onChanged(value - 1) : null,
              ),
              Text('$value'),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: value < max ? () => onChanged(value + 1) : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
