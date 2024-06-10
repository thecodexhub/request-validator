import 'package:request_validator/request_validator.dart';
import 'package:test/test.dart';

void main() {
  group('ValidationRule', () {
    ValidationRule createBodySubject({
      String? fieldName,
      bool Function(dynamic)? validator,
      bool? optional,
      String? message,
    }) {
      return ValidationRule.body(
        fieldName ?? 'name',
        validator ?? (value) => value is Object,
        optional: optional ?? false,
        message: message ?? 'Name is required',
      );
    }

    ValidationRule createQuerySubject({
      String? fieldName,
      bool Function(String)? validator,
      bool? optional,
      String? message,
    }) {
      return ValidationRule.query(
        fieldName ?? 'name',
        validator ?? (value) => value.isNotEmpty,
        optional: optional ?? false,
        message: message ?? 'Name is required',
      );
    }

    group('contructor', () {
      test('works perfectly', () {
        expect(createBodySubject, returnsNormally);
        expect(createQuerySubject, returnsNormally);
      });
    });

    test('hashCode is correct', () {
      final subject = createBodySubject();
      expect(
        subject.hashCode,
        Object.hashAll(
          [
            subject.location,
            subject.fieldName,
            subject.validator,
            subject.optional,
            subject.message,
          ],
        ),
      );
    });

    test('supports equality', () {
      bool mockValidator(dynamic value) => value is Object;
      expect(
        createBodySubject(validator: mockValidator),
        equals(createBodySubject(validator: mockValidator)),
      );
    });

    group('toString', () {
      test('works correctly', () {
        expect(
          createBodySubject().toString(),
          equals(
            '''ValidationRule.body(name, Closure: (dynamic) => bool, optional: false, message: Name is required)''',
          ),
        );
        expect(
          createQuerySubject().toString(),
          equals(
            '''ValidationRule.query(name, Closure: (dynamic) => bool, optional: false, message: Name is required)''',
          ),
        );
      });
    });
  });
}
