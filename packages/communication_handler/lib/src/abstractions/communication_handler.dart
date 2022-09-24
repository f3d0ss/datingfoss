abstract class CommunicationHandler {
  Future<dynamic> post(
    String actionName,
    dynamic data, {
    bool authenticated = false,
  });
  Future<dynamic> get(
    String actionName, {
    Map<String, dynamic>? queryParameters,
    bool authenticated = false,
  });
  Future<dynamic> download(
    String actionName,
    String savePath, {
    Map<String, dynamic>? queryParameters,
    bool authenticated = false,
  });

  void setToken({required String accessToken, required String refreshToken});
  void unsetToken();
}
