import 'dart:convert';

import 'package:controllers/controllers.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

extension PrivateInfoExtension on PrivateInfo {
  PrivateInfoDTO toPrivateInfoDTO({
    required SymmetricEncryptionService encryptionService,
    required String username,
  }) {
    return PrivateInfoDTO(
      bio: _getEncrypted(
        bio,
        username,
        encryptionService,
      ),
      textInfo: _getEncrypted(
        textInfo,
        username,
        encryptionService,
      ),
      boolInfo: _getEncrypted(
        boolInfo,
        username,
        encryptionService,
      ),
      dateInfo: _getEncrypted(
        dateInfo.map((key, date) => MapEntry(key, date.toIso8601String())),
        username,
        encryptionService,
      ),
      interests: _getEncrypted(
        interests,
        username,
        encryptionService,
      ),
      location: _getEncrypted(
        location,
        username,
        encryptionService,
      ),
      searching: _getEncrypted(
        searching,
        username,
        encryptionService,
      ),
      sex: _getEncrypted(
        sex,
        username,
        encryptionService,
      ),
    );
  }

  EncryptedDataDTO? _getEncrypted(
    dynamic dataToEncrypt,
    String username,
    SymmetricEncryptionService encryptionService,
  ) {
    if (dataToEncrypt == null) return null;
    return EncryptedDataDTO(
      encryptionService.encryptWithLastKey(
        plainText: json.encode(dataToEncrypt),
        username: username,
      ),
      encryptionService.lastKeyIndex,
    );
  }
}
