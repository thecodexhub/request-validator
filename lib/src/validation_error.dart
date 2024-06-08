import 'package:meta/meta.dart';
import 'package:request_validator/request_validator.dart';

/// {@template validation_error}
/// A [ValidationError] represents an error caused from a request
/// field validation.
///
/// It contains information about where the field is located,
/// what the value is, and associated error message, if any.
/// {@endtemplate}
@immutable
class ValidationError {
  /// {@macro validation_error}
  const ValidationError({
    required this.fieldName,
    required this.value,
    this.errorMessage,
  });

  /// The name of the field
  final String fieldName;

  /// The value of the field
  final dynamic value;

  /// The error message to be used when the field validation fails.
  final String? errorMessage;

  @override
  bool operator ==(covariant ValidationError other) {
    if (identical(this, other)) return true;

    return other.fieldName == fieldName &&
        other.value == value &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode {
    return Object.hashAll([fieldName, value, errorMessage]);
  }

  @override
  String toString() {
    return errorMessage == null
        ? '''ValidationError(fieldName: $fieldName, value: $value)'''
        : '''ValidationError(fieldName: $fieldName, value: $value, errorMessage: $errorMessage)''';
  }
}

/// Extension on list of [ValidationError]
extension ValidationErrorX on List<ValidationError> {
  /// Converts list of [ValidationError] to [JsonMap].
  JsonMap toMapArray() {
    return {'errors': map((error) => error.errorMessage).toList()};
  }
}
