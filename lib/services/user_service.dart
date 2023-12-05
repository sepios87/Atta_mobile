import 'package:atta/entities/user.dart';
import 'package:atta/mock.dart';
import 'package:rxdart/rxdart.dart';

class UserService {
  final _userStreamController = BehaviorSubject<AttaUser?>.seeded(null);

  AttaUser? get user => _userStreamController.value;
  Stream<AttaUser?> get userStream => _userStreamController.stream;
  bool get isLogged => user != null;

  Future<void> init() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    // await login('', '');
  }

  Future<void> logout() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    _userStreamController.add(null);
  }

  Future<void> login(String email, String password) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    _userStreamController.add(mockedUser);
  }
}
