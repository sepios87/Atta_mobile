part of 'home_base_cubit.dart';

@immutable
class HomeBaseState {
  const HomeBaseState({
    required this.user,
  });

  factory HomeBaseState.initial({required AttaUser? user}) {
    return HomeBaseState(user: user);
  }

  final AttaUser? user;

  HomeBaseState copyWith({
    Wrapped<AttaUser?>? user,
  }) {
    return HomeBaseState(
      user: user == null ? this.user : user.value,
    );
  }
}
