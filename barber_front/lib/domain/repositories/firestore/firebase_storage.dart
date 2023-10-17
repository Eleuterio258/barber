import 'dart:io';
import 'package:barber_front/domain/repositories/firestore/i_file_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService implements IFileStorage {
  final FirebaseStorage firebaseStorage;

  FirebaseStorageService({required this.firebaseStorage});

  @override
  Future<String> uploadImage(String path, File file) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(path);
      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask.whenComplete(() => null);
      return await snapshot.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      if (e.code == 'canceled') {
        throw Exception('Upload da imagem cancelado.');
      } else if (e.code == 'permission-denied') {
        throw Exception('Permissão negada durante o upload da imagem.');
      } else {
        throw Exception('Erro durante o upload da imagem.');
      }
    } catch (e) {
      throw Exception(
          'Ocorreu um erro desconhecido durante o upload da imagem.');
    }
  }

  @override
  Future<void> deleteImage(String path) async {
    try {
      final ref = firebaseStorage.ref().child(path);
      await ref.delete();
    } on Exception catch (e) {
      throw throw (message: e);
    }
  }

  @override
  Future<String> getImageUrl(String path) async {
    try {
      final ref = firebaseStorage.ref().child(path);
      return await ref.getDownloadURL();
    } on Exception catch (e) {
      throw throw (message: e);
    }
  }

  @override
  Future<String> uploadImages(List<String> paths, List<File> files) async {
    try {
      List<Future<String>> uploadTasks = [];

      for (int i = 0; i < paths.length; i++) {
        final ref = firebaseStorage.ref().child(paths[i]);
        final uploadTask = ref.putFile(files[i]);
        uploadTasks.add(uploadTask.whenComplete(() => null).then((snapshot) {
          return snapshot.ref.getDownloadURL();
        }));
      }

      List<String> downloadUrls = await Future.wait(uploadTasks);
      return downloadUrls.join(', ');
    } on Exception catch (e) {
      throw throw (message: e);
    }
  }
}
