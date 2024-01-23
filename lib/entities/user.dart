import 'package:isar/isar.dart';

part 'user.g.dart';

@collection
class AttaUser {
  AttaUser({
    required this.email,
    required this.password,
    this.firstName,
    this.lastName,
    this.phone,
    this.imageUrl,
  });

  @Index(unique: true)
  final id = Isar.autoIncrement;
  final String email;
  final String password;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? imageUrl;
  final List<String> favoritesRestaurantsId = [];
  final List<String> favoritesDishesId = [];
  final List<String> favoritesMenusId = [];
}
