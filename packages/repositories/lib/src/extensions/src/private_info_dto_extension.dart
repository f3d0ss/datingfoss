import 'dart:convert';

import 'package:controllers/controllers.dart';
import 'package:latlong2/latlong.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

extension PrivateInfoDTOExtension on PrivateInfoDTO {
  PrivateInfo toLocalPrivateInfo({
    required SymmetricEncryptionService encryptionService,
    required List<String> keys,
    required String username,
    List<PrivatePic>? pics,
  }) {
    final unencryptedLocation = _getUnencryptedMap<dynamic>(
      location,
      encryptionService,
      keys,
      username,
    );
    return PrivateInfo(
      bio: _getUnencrypted<String>(bio, encryptionService, keys, username),
      textInfo: _getUnencryptedMap<String>(
            textInfo,
            encryptionService,
            keys,
            username,
          ) ??
          <String, String>{},
      boolInfo: _getUnencryptedMap<bool>(
            boolInfo,
            encryptionService,
            keys,
            username,
          ) ??
          <String, bool>{},
      dateInfo: (_getUnencryptedMap<String>(
                dateInfo,
                encryptionService,
                keys,
                username,
              ) ??
              <String, String>{})
          .map((key, value) => MapEntry(key, DateTime.parse(value))),
      interests: _getUnencryptedList<String>(
            interests,
            encryptionService,
            keys,
            username,
          ) ??
          <String>[],
      location: unencryptedLocation == null
          ? null
          : LatLng.fromJson(unencryptedLocation),
      pictures: pics ??
          (pictures ?? <PrivatePictureDTO>{})
              .map((e) => PrivatePic(picId: e.id, keyIndex: e.key))
              .toList(),
      searching: searching == null
          ? null
          : RangeValues.fromJson(
              _getUnencryptedMap<dynamic>(
                searching,
                encryptionService,
                keys,
                username,
              )!,
            ),
      sex: _getUnencrypted<double>(sex, encryptionService, keys, username),
    );
  }

  T? _getUnencrypted<T>(
    EncryptedDataDTO? encryptedData,
    SymmetricEncryptionService encryptionService,
    List<String> keys,
    String username,
  ) {
    if (encryptedData == null) return null;
    try {
      return json.decode(
        encryptionService.decrypt(
          base64Encoded: encryptedData.encoded,
          base64Key: keys[encryptedData.keyIndex],
          username: username,
        ),
      ) as T;
    } catch (_) {
      return null;
    }
  }

  Map<String, T>? _getUnencryptedMap<T>(
    EncryptedDataDTO? encryptedData,
    SymmetricEncryptionService encryptionService,
    List<String> keys,
    String username,
  ) {
    if (encryptedData == null) return null;
    try {
      final dynamicMap = json.decode(
        encryptionService.decrypt(
          base64Encoded: encryptedData.encoded,
          base64Key: keys[encryptedData.keyIndex],
          username: username,
        ),
      ) as Map<String, dynamic>;
      final map = dynamicMap.map<String, T>(
        (key, dynamic value) => MapEntry(key, value as T),
      );
      return map;
    } catch (_) {
      return null;
    }
  }

  List<T>? _getUnencryptedList<T>(
    EncryptedDataDTO? encryptedData,
    SymmetricEncryptionService encryptionService,
    List<String> keys,
    String username,
  ) {
    if (encryptedData == null) return null;
    try {
      final dynamicList = json.decode(
        encryptionService.decrypt(
          base64Encoded: encryptedData.encoded,
          base64Key: keys[encryptedData.keyIndex],
          username: username,
        ),
      ) as List<dynamic>;
      final list = dynamicList.map<T>((dynamic value) => value as T).toList();
      return list;
    } catch (_) {
      return null;
    }
  }
}
