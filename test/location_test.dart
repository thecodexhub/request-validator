// ignore_for_file: prefer_const_declarations

import 'package:request_validator/request_validator.dart';
import 'package:test/test.dart';

void main() {
  group('Location', () {
    group('BODY', () {
      test('has correct value and toString', () {
        final location = Location.body;
        expect(location.value, equals('BODY'));
        expect(location.toString(), 'Location.body');
      });
    });

    group('HEADERS', () {
      test('has correct value and toString', () {
        final location = Location.headers;
        expect(location.value, equals('HEADERS'));
        expect(location.toString(), 'Location.headers');
      });
    });

    group('QUERY', () {
      test('has correct value and toString', () {
        final location = Location.query;
        expect(location.value, equals('QUERY'));
        expect(location.toString(), 'Location.query');
      });
    });
  });
}
