import 'package:atta/entities/user.dart';

extension AttaUserExt on AttaUser {
  String get anagram {
    final StringBuffer buffer = StringBuffer();
    if (firstName != null) buffer.write(firstName![0]);
    if (lastName != null) buffer.write(lastName![0]);
    if (lastName == null && firstName == null) buffer.write(email[0]);
    return buffer.toString().toUpperCase();
  }
}
