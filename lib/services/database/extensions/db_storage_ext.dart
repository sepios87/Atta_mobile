part of '../db_service.dart';

extension DatabaseStorageService on DatabaseService {
  Future<String> uploadUserAvatar(String path, File file) async {
    await _supabase.storage.from('users').upload(path, file);
    return _supabase.storage.from('users').getPublicUrl(path);
  }
}
