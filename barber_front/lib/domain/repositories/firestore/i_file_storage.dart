import 'dart:io';

abstract interface class IFileStorage {
  Future<String> uploadImage(String path, File file);
  Future<void> deleteImage(String path);
  Future<String> getImageUrl(String path);
  Future<String> uploadImages(List<String> paths, List<File> files);
}


