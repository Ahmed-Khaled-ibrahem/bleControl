part of 'app_cubit.dart';

sealed class AppState extends Equatable {
  const AppState();
}

final class AppInitial extends AppState {
  @override
  List<Object> get props => [];
}


class MyState extends AppState {
  final int refreshKey; // Random number or timestamp

  const MyState({required this.refreshKey});

  @override
  List<Object> get props => [refreshKey];
}
