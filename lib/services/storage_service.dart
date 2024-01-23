import 'package:atta/entities/user.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class StorageSevice {
  late Isar isar;

  Future<void> initDatabase() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [AttaUserSchema],
      directory: dir.path,
    );
  }

  Future<void> saveUser(AttaUser user) async {
    final test = await isar.writeTxn(() async {
      final ok = await isar.attaUsers.put(user);
      // print(ok);
    });
    // print(test);
  }

  Future<bool> isUserExist(String email) async {
    return isar.attaUsers.where().filter().emailEqualTo(email).isNotEmpty();
  }

  Future<AttaUser?> getUser(
    String email,
    String password,
  ) async {
    print(await isar.attaUsers.where().filter().emailEqualTo(email).passwordEqualTo(password).count());
    return isar.attaUsers.where().filter().emailEqualTo(email).passwordEqualTo(password).findFirst();
  }

  // Future<AttaUser?> getUserWithEmail
  //   return await isar.attaUsers.getSingle();
  // }
}
