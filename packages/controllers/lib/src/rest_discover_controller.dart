import 'dart:io';

import 'package:communication_handler/communication_handler.dart';
import 'package:controllers/controllers.dart';

class RestDiscoverController extends DiscoverController {
  RestDiscoverController({
    required CommunicationHandler communicationHandler,
    required String directoryToStoreFiles,
  })  : _communicationHandler = communicationHandler,
        _directoryToStoreFiles = directoryToStoreFiles;

  static const baseAction = 'Discover';
  final CommunicationHandler _communicationHandler;
  final String _directoryToStoreFiles;

  @override
  Future<List<UserDTO>> fetchPartners({
    int numberOfPartner = 2,
    List<String> alreadyFetchedUsers = const [],
    dynamic options,
  }) async {
    final request = {
      'resultsLimit': 1,
      'excludedUsernames': alreadyFetchedUsers
    };
    final result = await _communicationHandler.post(
      '$baseAction/PossiblePartners',
      request,
      authenticated: true,
    ) as List<dynamic>;
    final partners = result
        .map((dynamic e) => UserDTO.fromJson(e as Map<String, dynamic>))
        .toList();
    return partners;
  }

  @override
  Future<void> sendSealedLikeMessage({
    required String to,
    required String sealedLikeMessage,
  }) async {
    final request = {
      'toUsername': to,
      'content': sealedLikeMessage,
    };
    await _communicationHandler.post('$baseAction/SendLikeMessage', request);
  }

  @override
  Future<File> fetchPartnerPublicPicture({
    required String username,
    required String id,
  }) async {
    return _fetchPic(username: username, id: id);
  }

  @override
  Future<File> fetchPartnerEncryptedPrivatePicture({
    required String username,
    required String id,
  }) async {
    return _fetchPic(username: username, id: id, private: true);
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
  Future<Map<String, dynamic>> fetchPublicKey({
    required String username,
  }) async {
    final request = {
      'username': username,
    };
    final result = await _communicationHandler.get(
      '/User/PublicKey',
      queryParameters: request,
    ) as Map<String, dynamic>;
    return result;
  }

  @override
  Future<UserDTO> fetchPartner({required String username}) async {
    final request = {
      'username': username,
    };
    final result = await _communicationHandler.get(
      '/User',
      queryParameters: request,
      authenticated: true,
    ) as Map<String, dynamic>;
    final partner = UserDTO.fromJson(result);
    return partner;
  }
}
