part of 'bottom_navigation_cubit.dart';

@immutable
class BottomNavigationState {
  const BottomNavigationState({
    required this.user,
  });

  factory BottomNavigationState.initial({required AttaUser? user}) {
    return BottomNavigationState(user: user);
  }

  final AttaUser? user;

  BottomNavigationState copyWith({
    AttaUser? user,
  }) {
    return BottomNavigationState(
      user: user ?? this.user,
    );
  }
}
