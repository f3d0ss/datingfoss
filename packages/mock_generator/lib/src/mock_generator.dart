// ignore_for_file: avoid_print, public_member_api_docs

import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

import 'package:mock_generator/src/mock_user_generator.dart';
import 'package:mock_generator/src/mock_user_list.dart';

class MockGenerator {
  MockGenerator({
    this.baseURL = 'http://10.147.18.11:5202/',
    this.basePath = '',
  });

  final String baseURL;
  final String basePath;

  Future<void> seedServer() async {
    final localUser = MockUserGenerator(
      MockUserList(basePath: basePath).getLoginUser(),
      baseURL,
      basePath: basePath,
    );
    await localUser.signUp();
    final localAsPartner = localUser.toPartner();

    for (final user in MockUserList(basePath: basePath).getList()) {
      final userMocker = MockUserGenerator(user, baseURL, basePath: basePath);
      await userMocker.signUp();
      await userMocker.putLike(localAsPartner);
    }

    await Directory('${basePath}tmp/').list().forEach((element) {
      element.delete();
    });
  }

  Future<void> cleanServer() async {
    await Dio(BaseOptions(baseUrl: baseURL))
        .post<dynamic>('User/ClearAllUsers');
  }
}
