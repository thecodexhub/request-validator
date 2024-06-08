import 'package:request_validator/request_validator.dart';
import 'package:test/test.dart';

void main() {
  group('ValidationError', () {
    ValidationError createSubject({
      String? fieldName,
      dynamic value,
      String? errorMessage,
    }) {
      return ValidationError(
        fieldName: fieldName ?? 'name',
        value: value ?? 'test',
        errorMessage: errorMessage,
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
            subject.fieldName,
            subject.value,
            subject.errorMessage,
          ],
        ),
      );
    });

    test('supports equality', () {
      expect(
        createSubject(),
        equals(createSubject()),
      );
    });

    group('toString', () {
      test('works correctly when there is a errorMessage', () {
        expect(
          createSubject(errorMessage: 'test').toString(),
          equals(
            '''ValidationError(fieldName: name, value: test, errorMessage: test)''',
          ),
        );
      });

      test('works correctly when there is no errorMessage', () {
        expect(
          createSubject().toString(),
          equals('ValidationError(fieldName: name, value: test)'),
        );
      });
    });
  });
}
