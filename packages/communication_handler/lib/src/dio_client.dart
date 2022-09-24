import 'package:communication_handler/communication_handler.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:fresh_dio/fresh_dio.dart';
export 'package:fresh/fresh.dart' show AuthenticationStatus;

class DioClient extends CommunicationHandler {
  DioClient({
    Dio? httpClient,
    Dio? httpClientWithoutToken,
    String baseURL = 'http://10.147.18.11:5202/',
  })  : _httpClient = (httpClient ?? Dio())
          ..options.baseUrl = baseURL
          ..interceptors.add(_fresh)
          ..interceptors.add(
            LogInterceptor(
              request: false,
              responseHeader: false,
              responseBody: true,
            ),
          ),
        _httpClientWithoutToken = (httpClientWithoutToken ?? Dio())
          ..options.baseUrl = baseURL
          ..interceptors.add(
            LogInterceptor(
              request: false,
              responseHeader: false,
              responseBody: true,
            ),
          ) {
    _httpClient.interceptors
        .add(RetryInterceptor(dio: _httpClient, retryableExtraStatuses: {404}));
    _httpClientWithoutToken.interceptors.add(
      RetryInterceptor(
        dio: _httpClientWithoutToken,
        retryableExtraStatuses: {404},
      ),
    );
  }

  final Dio _httpClient;
  final Dio _httpClientWithoutToken;

  @override
  Future<dynamic> get(
    String actionName, {
    Map<String, dynamic>? queryParameters,
    bool authenticated = false,
  }) async {
    final httpClient = authenticated ? _httpClient : _httpClientWithoutToken;

    final response = await httpClient.get<dynamic>(
      actionName,
      queryParameters: queryParameters,
    );
    return response.data;
  }

  @override
  Future<dynamic> post(
    String actionName,
    dynamic data, {
    bool authenticated = false,
  }) async {
    final httpClient = authenticated ? _httpClient : _httpClientWithoutToken;
    final response = await httpClient.post<dynamic>(
      actionName,
      data: data,
    );
    return response.data;
  }

  @override
  Future<dynamic> download(
    String actionName,
    String savePath, {
    Map<String, dynamic>? queryParameters,
    bool authenticated = false,
  }) async {
    final httpClient = authenticated ? _httpClient : _httpClientWithoutToken;
    final response = await httpClient.download(
      actionName,
      savePath,
      queryParameters: queryParameters,
    );
    return response.data;
  }

  @override
  Future<void> setToken({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _fresh.setToken(
      OAuth2Token(
        accessToken: accessToken,
        refreshToken: refreshToken,
      ),
    );
  }

  @override
  Future<void> unsetToken() async {
    await _fresh.setToken(null);
  }

  static final _fresh = Fresh.oAuth2(
    tokenStorage: InMemoryTokenStorage<OAuth2Token>(),
    refreshToken: (token, client) async =>
        const OAuth2Token(accessToken: 'token'),
    // {
    // await Future<void>.delayed(const Duration(seconds: 1));
    // if (Random().nextInt(3) == 0) {
    //   throw RevokeTokenException();
    // }
    // _refreshCount++;
    // return OAuth2Token(
    //   accessToken: 'access_token_$_refreshCount',
    //   refreshToken: 'refresh_token_$_refreshCount',
    // );
    // },
    // shouldRefresh: (_) => Random().nextInt(3) == 0,
  );
}
