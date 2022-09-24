import 'dart:io';

import 'package:controllers/controllers.dart';
import 'package:path/path.dart' as path;

class MockUserController extends UserController {
  MockUserController({
    required Future<File> Function(String path) getImageFileFromAssets,
  }) : _getImageFileFromAssets = getImageFileFromAssets;

  static const baseAction = 'User';
  final Future<File> Function(String path) _getImageFileFromAssets;

  @override
  Future<List<File>> fetchEncryptedPrivatePics(
    List<String> picIds,
    String username,
  ) async {
    return [];
  }

  @override
  Future<List<File>> fetchPublicPics(
    List<String> picIds,
    String username,
  ) async {
    final pics = <File>[];
    for (final picId in picIds) {
      pics.add(await _getImageFileFromAssets('mock/$picId.jpg'));
    }
    return pics;
  }

  @override
  Future<UserDTO> fetchUser() async {
    return UserDTO(
      username: 'greve00',
      publicInfo: PublicInfoDTO(
        bio: 'public bio',
        interests: const ['computers', 'patate', 'pussy', 'no balls'],
        textInfo: const {'Name': 'bob', 'Surname': 'rob', 'Ass': 'big'},
        dateInfo: {'Birthdate': DateTime.now()},
        boolInfo: const {'smoker': false},
        sex: 0.6,
        searching: const RangeValuesDTO(0.7, 1),
        pictures: const [
          'pic1',
          'pic2',
          'pic3',
          'pic4',
          'pic5',
          'pic1',
          'pic2',
          'pic3',
          'pic4'
        ],
        location: const LocationDTO(10, 60),
      ),
      privateInfo: const PrivateInfoDTO(),
      publicKey: <String, dynamic>{
        'exponent': 'AQAB',
        'modulus':
            'gtUzZU4p3Yw/dN1bJqIC77w9g3nWzdgD89jz9A8u8Ffm4NaN8xpWiPJEIIj703B/ZhP6GkqBaQSJe1ldea98waJ+ibhZzFKkTORagxPyi/jp1qDZbEL1Co/SCjVJm+X5NJkVjgMBljVEQNJHS+4jm+YtRslxSIL6Q/y9/5PsxURX84WK71b5UHjLmsKJGRuYW/d8yCrV/yftWXOX1S3mQzwkdAm3kPQYCKTpQrAksJADsVWPssOo3Nd/6qsGOhpvLm2PqHgJKnp3k8iskmyZb6Rs/UrT51rrdo+WaIdzR4nOCtjTVkzWK2hHbq9qLCqhKTJ2RSOaN12UGzT49XueuQ=='
      },
    );
  }

  @override
  Future<String> pushEncryptedPrivatePic(
    File encryptedPic,
    int indexKey,
  ) async {
    return path.basename(encryptedPic.path);
  }

  @override
  Future<String> pushPublicPic(File pic) async {
    return path.basename(pic.path);
  }

  @override
  Future<void> pushUser(UserDTO userDTO) async {
    return;
  }

  @override
  Future<String> fetchSymmetricEncryptedKeys() async {
    return 'HV9EBolu2N/gchHTQpzoJVoGxU2/sghVLOgqGoJJIOKNwPQw6X6LUZvZGTWy+2w37YBmXW4LbwUI8XfwMPFIRBgvIwdIGA91f+FNB+SeGRTSENx1hTK0KFJwXjN+sesw5P65Tv6z9Dny3ce9k2agQvrp07/dzaeQrtVC4G9rvNYJYFxniO2u7WA9+clKxtGngU7C1Cp76k6/xjp5pVgDA7+4EfggL2WyMwBh8uRm9OK84QLJazCtrsbZMcSEvI3CmAqRtB61/5NM+ffQj+ZaNEoGo1YDifzbz8sls5YOXYpU0A9ztrJtgHQ3/bWPiKxMG/P//oHnNePETT+BeZaQIw==';
  }

  @override
  Future<void> pushSymmetricEncryptedKeys(String encryptedKeys) async {}
}
