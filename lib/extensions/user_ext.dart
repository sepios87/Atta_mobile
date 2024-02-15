import 'package:atta/entities/user.dart';

extension AttaUserExt on AttaUser {
  String? get anagram {
    if (firstName == null && lastName == null) return null;
    final StringBuffer buffer = StringBuffer();
    if (firstName != null && firstName!.isNotEmpty) buffer.write(firstName![0]);
    if (lastName != null && lastName!.isNotEmpty) buffer.write(lastName![0]);
    return buffer.toString().toUpperCase();
  }
}
