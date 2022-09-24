import 'package:communication_handler/communication_handler.dart';
import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockDio extends Mock implements Dio {}

void main() {
  group('CommunicationHandler', () {
    late Dio dio;
    setUp(() {
      dio = MockDio();
      when(() => dio.interceptors).thenReturn(Interceptors());
      when(() => dio.options).thenReturn(BaseOptions());
    });

    test('can be istantiated', () {
      expect(
        DioClient(
          httpClient: dio,
          httpClientWithoutToken: dio,
        ),
        isNotNull,
      );
      expect(DioClient(), isNotNull);
    });

    group('with DioClient istantiated', () {
      late CommunicationHandler communicationHandler;
      setUp(() {
        communicationHandler = DioClient(
          httpClient: dio,
          httpClientWithoutToken: dio,
        );
      });
      test('can setToken', () {
        communicationHandler.setToken(
          accessToken: 'accessToken',
          refreshToken: 'refreshToken',
        );
      });

      test('can unsetToken', () {
        communicationHandler.unsetToken();
      });
      group('http', () {
        late String route;
        late Map<String, dynamic> request;
        late Map<String, dynamic> mockResponse;
        late Response<dynamic> response;
        late String savePath;
        setUp(() {
          route = 'url';
          request = <String, dynamic>{};
          mockResponse = <String, String>{'message': 'Success!'};
          response = Response<dynamic>(
            requestOptions: RequestOptions(path: route),
            data: mockResponse,
          );
          savePath = 'path';
          when(() => dio.post<dynamic>(route, data: request)).thenAnswer(
            (_) async => response,
          );
          when(() => dio.get<dynamic>(route, queryParameters: request))
              .thenAnswer((_) async => response);
          when(() => dio.download(route, savePath))
              .thenAnswer((_) async => response);
        });
        test('can post', () async {
          var response = await communicationHandler.post(route, request)
              as Map<String, dynamic>;
          expect(response, mockResponse);

          response = await communicationHandler.post(
            route,
            request,
            authenticated: true,
          ) as Map<String, dynamic>;
          expect(response, mockResponse);
        });

        test('can get', () async {
          var response = await communicationHandler.get(
            route,
            queryParameters: request,
          ) as Map<String, dynamic>;
          expect(response, mockResponse);

          response = await communicationHandler.get(
            route,
            queryParameters: request,
            authenticated: true,
          ) as Map<String, dynamic>;
          expect(response, mockResponse);
        });

        test('can download', () async {
          var response = await communicationHandler.download(route, savePath)
              as Map<String, dynamic>;
          expect(response, mockResponse);

          response = await communicationHandler.download(
            route,
            savePath,
            authenticated: true,
          ) as Map<String, dynamic>;
          expect(response, mockResponse);
        });
      });
    });
  });
}
