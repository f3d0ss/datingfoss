import 'dart:io';

import 'package:communication_handler/communication_handler.dart';
import 'package:controllers/controllers.dart';
import 'package:mime/mime.dart';

class RestUserController extends UserController {
  RestUserController({
    required CommunicationHandler communicationHandler,
    required String directoryToStoreFiles,
  })  : _communicationHandler = communicationHandler,
        _directoryToStoreFiles = directoryToStoreFiles;

  final CommunicationHandler _communicationHandler;
  static const baseAction = 'User';
  final String _directoryToStoreFiles;

  @override
  Future<List<File>> fetchEncryptedPrivatePics(
    List<String> picIds,
    String username,
  ) async {
    final futurePics = picIds.map<Future<File>>(
      (picId) async => _fetchPic(username: username, id: picId, private: true),
    );
    return Future.wait(futurePics);
  }

  @override
  Future<List<File>> fetchPublicPics(
    List<String> picIds,
    String username,
  ) async {
    final futurePics = picIds.map<Future<File>>(
      (picId) async => _fetchPic(username: username, id: picId),
    );
    return Future.wait(futurePics);
  }

  Future<File> _fetchPic({
    required String username,
    required String id,
    bool private = false,
  }) async {
    final filePath =
        '$_directoryToStoreFiles/${private ? 'encrypted' : 'public'}/$id';
    final file = File(filePath);
    await _communicationHandler.download(
      'User/$username/${private ? 'Private' : 'Public'}Picture',
      filePath,
      queryParameters: <String, String>{'pictureName': id},
      authenticated: !private,
    );
    return file;
  }

  @override
  Future<UserDTO> fetchUser() async {
    final response = await _communicationHandler.get(
      baseAction,
      authenticated: true,
    ) as Map<String, dynamic>;
    return UserDTO.fromJson(response);
  }

  @override
  Future<String> pushEncryptedPrivatePic(
    File encryptedPic,
    int indexKey,
  ) async {
    final mime = lookupMimeType(encryptedPic.path);
    final formData = FormData.fromMap(<String, dynamic>{
      'Picture': await MultipartFile.fromFile(
        encryptedPic.path,
        contentType: mime != null ? MediaType.parse(mime) : null,
      ),
      'KeyIndex': indexKey,
    });
    final result = await _communicationHandler.post(
      '$baseAction/UploadPrivatePicture',
      formData,
      authenticated: true,
    ) as Map<String, dynamic>;
    return result['pictureName']! as String;
  }

  @override
  Future<String> pushPublicPic(File pic) async {
    final mime = lookupMimeType(pic.path);
    final formData = FormData.fromMap(<String, dynamic>{
      'Picture': await MultipartFile.fromFile(
        pic.path,
        contentType: mime != null ? MediaType.parse(mime) : null,
      ),
    });
    final result = await _communicationHandler.post(
      '$baseAction/UploadPublicPicture',
      formData,
      authenticated: true,
    ) as Map<String, dynamic>;
    return result['pictureName']! as String;
  }

  @override
  Future<void> pushUser(UserDTO userDTO) async {
    await _communicationHandler.post(
      '$baseAction/UpdateData',
      userDTO.toJson(),
      authenticated: true,
    );
  }

  @override
  Future<String> fetchSymmetricEncryptedKeys() async {
    return await _communicationHandler.get(
      '$baseAction/SymmetricKeys',
      authenticated: true,
    ) as String;
  }

  @override
  Future<void> pushSymmetricEncryptedKeys(String encryptedKeys) async {
    await _communicationHandler.post(
      '$baseAction/SymmetricKeys',
      '"$encryptedKeys"',
      authenticated: true,
    );
  }
}
