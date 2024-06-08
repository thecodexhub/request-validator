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

      setUp(() {
        context = _MockRequestContext();
        request = _MockRequest();
        when(() => request.method).thenReturn(HttpMethod.post);
        when(request.json).thenAnswer(
          (_) => Future.value({'age': 24}),
        );
        when(() => context.request).thenReturn(request);
      });

      test('returns 400 with correct body when field does not exist', () async {
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

      test('returns 400 with correct body when validation fails', () async {
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

      test('returns 200 with correct body when validation succeeds', () async {
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
  });
}
