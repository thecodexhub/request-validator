import 'package:request_validator/request_validator.dart';
import 'package:test/test.dart';

void main() {
  group('ValidationRule', () {
    ValidationRule createSubject({
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

    group('contructor', () {
      test('works perfectly', () {
        expect(createSubject, returnsNormally);
      });
    });

    test('hashCode is correct', () {
      final subject = createSubject();
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
        createSubject(validator: mockValidator),
        equals(createSubject(validator: mockValidator)),
      );
    });

    group('toString', () {
      test('works correctly', () {
        expect(
          createSubject().toString(),
          equals(
            '''ValidationRule.body(name, Closure: (dynamic) => bool, optional: false, message: Name is required)''',
          ),
        );
      });
    });
  });
}
