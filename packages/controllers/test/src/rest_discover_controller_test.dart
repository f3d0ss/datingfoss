import 'dart:convert';

import 'package:communication_handler/communication_handler.dart';
import 'package:controllers/controllers.dart';
import 'package:controllers/src/rest_discover_controller.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockCommunicationHandler extends Mock implements CommunicationHandler {}

void main() {
  group('RestDiscoverController', () {
    late CommunicationHandler communicationHandler;
    late String directoryToStoreFiles;
    setUp(() {
      communicationHandler = MockCommunicationHandler();
      directoryToStoreFiles = 'dir';
    });

    test('can be instantiated', () {
      expect(
        RestDiscoverController(
          communicationHandler: communicationHandler,
          directoryToStoreFiles: directoryToStoreFiles,
        ),
        isNotNull,
      );
    });

    group('with instantiated RestDiscoverController', () {
      late DiscoverController discoverController;
      late String baseAction;
      late String username;
      late int numberOfPartnerToFetch;
      late List<String> alreadyFetchedPartner;
      late UserDTO partner;
      late String sealedLikeMessage;
      late String publicPicId;
      late Map<String, dynamic> publicKey;
      setUp(() {
        discoverController = RestDiscoverController(
          communicationHandler: communicationHandler,
          directoryToStoreFiles: directoryToStoreFiles,
        );
        baseAction = RestDiscoverController.baseAction;
        username = 'alice';
        numberOfPartnerToFetch = 2;
        alreadyFetchedPartner = [];
        publicKey = <String, dynamic>{};
        partner = UserDTO(
          username: username,
          publicInfo: const PublicInfoDTO(),
          privateInfo: const PrivateInfoDTO(),
          publicKey: publicKey,
        );
        sealedLikeMessage = 'sealdLikeMessage';
        publicPicId = 'publicPicId';

        final fetchPartnerRequest = {
          'resultsLimit': 1,
          'excludedUsernames': alreadyFetchedPartner
        };
        when(
          () => communicationHandler.post(
            '$baseAction/PossiblePartners',
            fetchPartnerRequest,
            authenticated: true,
          ),
        ).thenAnswer((_) async => <dynamic>[encodeJson(partner.toJson())]);

        final sendSealedLikeMessageRequest = {
          'toUsername': username,
          'content': sealedLikeMessage,
        };
        when(
          () => communicationHandler.post(
            '$baseAction/SendLikeMessage',
            sendSealedLikeMessageRequest,
          ),
        ).thenAnswer((_) async {});
        final fetchPublicKeyRequest = {'username': username};
        when(
          () => communicationHandler.get(
            '/User/PublicKey',
            queryParameters: fetchPublicKeyRequest,
          ),
        ).thenAnswer((_) async => publicKey);
        final fetchUser = {'username': username};
        when(
          () => communicationHandler.get(
            '/User',
            queryParameters: fetchUser,
            authenticated: true,
          ),
        ).thenAnswer((_) async => encodeJson(partner.toJson()));
        when(
          () => communicationHandler.download(
            any(),
            any(),
            queryParameters: any(named: 'queryParameters'),
            authenticated: any(named: 'authenticated'),
          ),
        ).thenAnswer((_) async {});
      });

      test('can fetchPartners', () {
        discoverController.fetchPartners(
          alreadyFetchedUsers: alreadyFetchedPartner,
          numberOfPartner: numberOfPartnerToFetch,
        );
      });

      test('can sendSealedLikeMessage', () {
        discoverController.sendSealedLikeMessage(
          sealedLikeMessage: sealedLikeMessage,
          to: username,
        );
      });

      test('can fetchPartnerPublicPicture', () {
        discoverController.fetchPartnerPublicPicture(
          username: username,
          id: publicPicId,
        );
      });

      test('can fetchPartnerEncryptedPrivatePicture', () {
        discoverController.fetchPartnerEncryptedPrivatePicture(
          username: username,
          id: publicPicId,
        );
      });

      test('can fetchPublicKey', () {
        discoverController.fetchPublicKey(username: username);
      });

      test('can fetchPartner', () {
        discoverController.fetchPartner(username: username);
      });
    });
  });
}

dynamic encodeJson(Map<String, dynamic> jsonObject) =>
    json.decode(json.encode(jsonObject));
