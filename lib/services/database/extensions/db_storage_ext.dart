part of '../db_service.dart';

extension DatabaseStorageService on DatabaseService {
  Future<void> uploadUserAvatar(String path, File file) async {
    print('Uploading avatar $path');
    final response = await _supabase.storage.from('users').upload(
          path,
          file,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
        );
    print(response);
  }
}
