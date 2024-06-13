// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:request_validator/request_validator.dart';
import 'package:test/test.dart';

import 'helpers/helpers.dart';

class _MockRequestContext extends Mock implements RequestContext {}

class _MockRequest extends Mock implements Request {}

class _MockUri extends Mock implements Uri {}

void main() {
  group('RequestValidator', () {
    RequestValidator createSubject() => PersonValidator();
    group('constructor', () {
      test('works correctly', () {
        expect(createSubject, returnsNormally);
      });

      test('has correct allowed methods', () {
        expect(createSubject().allowedMethods, [HttpMethod.post]);
      });
    });

    test('hashCode is correct', () {
      final subject = createSubject();
      expect(
        subject.hashCode,
        Object.hashAll([subject.allowedMethods]),
      );
    });

    test('supports equality', () {
      expect(createSubject(), equals(createSubject()));
    });

    test('defaultErrorMessage returns a formatted error message', () {
      expect(
        createSubject().defaultErrorMessage('name'),
        '''The field 'name' is invalid. Please check the validation rules for this field.''',
      );
    });

    test('serveAsMiddleware returns a Middleware function', () {
      final validator = createSubject();
      final middleware = validator.serveAsMiddleware();
      expect(middleware, isA<Middleware>());
    });

    group('middleware', () {
      late RequestContext context;
      late Request request;
      late Uri uri;

      group('body', () {
        setUp(() {
          context = _MockRequestContext();
          request = _MockRequest();
          uri = _MockUri();
          when(() => request.method).thenReturn(HttpMethod.post);
          when(() => request.headers).thenReturn(
            {HttpHeaders.contentTypeHeader: 'application/json'},
          );
          when(request.json).thenAnswer(
            (_) => Future.value({'age': 24}),
          );
          when(() => uri.queryParameters).thenReturn(
            {'code': '101'},
          );
          when(() => request.uri).thenReturn(uri);
          when(() => context.request).thenReturn(request);
        });

        test('returns 400 when field does not exist in request body', () async {
          final middleware = createSubject().serveAsMiddleware();
          final response = await middleware((_) async => Response())(context);
          expect(
            response,
            isA<Response>().having(
              (r) => r.statusCode,
              'statusCode',
              HttpStatus.badRequest,
            ),
          );
          expect(
            await response.body(),
            '''{"errors":["The field 'name' is invalid. Please check the validation rules for this field."]}''',
          );
        });

        test('returns 400 when validation fails in request body', () async {
          when(request.json).thenAnswer(
            (_) => Future.value({'name': 123, 'age': 24}),
          );
          final middleware = createSubject().serveAsMiddleware();
          final response = await middleware((_) async => Response())(context);
          expect(
            response,
            isA<Response>().having(
              (r) => r.statusCode,
              'statusCode',
              HttpStatus.badRequest,
            ),
          );
          expect(
            await response.body(),
            '''{"errors":["The field 'name' is invalid. Please check the validation rules for this field."]}''',
          );
        });

        test('returns 200 when validation succeeds with correct body',
            () async {
          when(request.json).thenAnswer(
            (_) => Future.value({'name': 'Bob', 'age': 24}),
          );
          final middleware = createSubject().serveAsMiddleware();
          final response = await middleware((_) async => Response())(context);
          expect(
            response,
            isA<Response>().having(
              (r) => r.statusCode,
              'statusCode',
              HttpStatus.ok,
            ),
          );
          expect(await response.body(), '');
        });
      });

      group('query', () {
        setUp(() {
          context = _MockRequestContext();
          request = _MockRequest();
          uri = _MockUri();
          when(() => request.method).thenReturn(HttpMethod.post);
          when(() => request.headers).thenReturn(
            {HttpHeaders.contentTypeHeader: 'application/json'},
          );
          when(request.json).thenAnswer(
            (_) => Future.value({'name': 'test', 'age': 24}),
          );
          when(() => uri.queryParameters).thenReturn(
            {'code': '101'},
          );
          when(() => request.uri).thenReturn(uri);
          when(() => context.request).thenReturn(request);
        });

        test('returns 400 when query does not exist', () async {
          when(() => uri.queryParameters).thenReturn({});
          final middleware = createSubject().serveAsMiddleware();
          final response = await middleware((_) async => Response())(context);
          expect(
            response,
            isA<Response>().having(
              (r) => r.statusCode,
              'statusCode',
              HttpStatus.badRequest,
            ),
          );
          expect(
            await response.body(),
            '''{"errors":["The field 'code' is invalid. Please check the validation rules for this field."]}''',
          );
        });

        test('returns 400 when query field fails validation', () async {
          when(() => uri.queryParameters).thenReturn({'code': 'test'});
          final middleware = createSubject().serveAsMiddleware();
          final response = await middleware((_) async => Response())(context);
          expect(
            response,
            isA<Response>().having(
              (r) => r.statusCode,
              'statusCode',
              HttpStatus.badRequest,
            ),
          );
          expect(
            await response.body(),
            '''{"errors":["The field 'code' is invalid. Please check the validation rules for this field."]}''',
          );
        });

        test('returns 200 when query field passes validation', () async {
          final middleware = createSubject().serveAsMiddleware();
          final response = await middleware((_) async => Response())(context);
          expect(
            response,
            isA<Response>().having(
              (r) => r.statusCode,
              'statusCode',
              HttpStatus.ok,
            ),
          );
          expect(await response.body(), '');
        });
      });

      group('headers', () {
        setUp(() {
          context = _MockRequestContext();
          request = _MockRequest();
          uri = _MockUri();
          when(() => request.method).thenReturn(HttpMethod.post);
          when(() => request.headers).thenReturn(
            {HttpHeaders.contentTypeHeader: 'application/json'},
          );
          when(request.json).thenAnswer(
            (_) => Future.value({'name': 'test', 'age': 24}),
          );
          when(() => uri.queryParameters).thenReturn(
            {'code': '101'},
          );
          when(() => request.uri).thenReturn(uri);
          when(() => context.request).thenReturn(request);
        });

        test('returns 400 when headers does not exist', () async {
          when(() => request.headers).thenReturn({});
          final middleware = createSubject().serveAsMiddleware();
          final response = await middleware((_) async => Response())(context);
          expect(
            response,
            isA<Response>().having(
              (r) => r.statusCode,
              'statusCode',
              HttpStatus.badRequest,
            ),
          );
          expect(
            await response.body(),
            '''{"errors":["The field 'content-type' is invalid. Please check the validation rules for this field."]}''',
          );
        });

        test('returns 400 when headers field fails validation', () async {
          when(() => request.headers).thenReturn(
            {HttpHeaders.contentTypeHeader: 'application/xml'},
          );
          final middleware = createSubject().serveAsMiddleware();
          final response = await middleware((_) async => Response())(context);
          expect(
            response,
            isA<Response>().having(
              (r) => r.statusCode,
              'statusCode',
              HttpStatus.badRequest,
            ),
          );
          expect(
            await response.body(),
            '''{"errors":["The field 'content-type' is invalid. Please check the validation rules for this field."]}''',
          );
        });

        test('returns 200 when headers passes validation', () async {
          final middleware = createSubject().serveAsMiddleware();
          final response = await middleware((_) async => Response())(context);
          expect(
            response,
            isA<Response>().having(
              (r) => r.statusCode,
              'statusCode',
              HttpStatus.ok,
            ),
          );
          expect(await response.body(), '');
        });
      });
    });
  });
}
