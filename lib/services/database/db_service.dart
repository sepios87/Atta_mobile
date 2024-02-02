import 'package:atta/entities/dish.dart';
import 'package:atta/entities/restaurant.dart';
import 'package:atta/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'extensions/db_user_ext.dart';
part 'extensions/db_restaurant_ext.dart';
part 'extensions/db_reservation_ext.dart';

class DatabaseService {
  final _supabase = Supabase.instance.client;

  User? get currentUser => _supabase.auth.currentUser;
}
