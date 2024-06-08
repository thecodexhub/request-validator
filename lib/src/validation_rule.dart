import 'package:meta/meta.dart';

/// {@template validation_rule}
/// A [ValidationRule] represents the validation logic of a single
/// field from the request.
///
/// It contains information about where the field is located,
/// what the validation logic is, and associated error message.
/// {@endtemplate}
@immutable
class ValidationRule {
  const ValidationRule._({
    required this.location,
    required this.fieldName,
    required this.validator,
    required this.optional,
    this.message,
  });

  /// Constructor which creates a [ValidationRule] for request body fields.
  const ValidationRule.body(
    String fieldName,
    bool Function(dynamic) validator, {
    bool? optional,
    String? message,
  }) : this._(
          location: 'body',
          fieldName: fieldName,
          validator: validator,
          optional: optional ?? false,
          message: message,
        );

  /// The location from where the field is picked. This parameter
  /// currently only extracts fields from request body to validate. Other
  /// locations, e.g., params, query, form-data will be introduced later.
  ///
  // TODO(thecodexhub): Add support for other field location.
  final String location;

  /// The name of the field.
  final String fieldName;

  /// Validation function that validates the field.
  /// It should return true when the validation is successful, otherwise false.
  final bool Function(dynamic) validator;

  /// Whether or not the field is optional.
  ///
  /// If set to true, it first checks whether the field was available of the
  /// `location`, and if it exists, it'll perform the validation logic.
  final bool optional;

  /// Message to be set when the field validation fails.
  ///
  /// If the message is null, a default message will be set
  /// at the time of validation failure.
  final String? message;

  @override
  bool operator ==(covariant ValidationRule other) {
    if (identical(this, other)) return true;

    return other.location == location &&
        other.fieldName == fieldName &&
        other.validator == validator &&
        other.optional == optional &&
        other.message == message;
  }

  @override
  int get hashCode {
    return Object.hashAll([location, fieldName, validator, optional, message]);
  }

  @override
  String toString() {
    return location == 'body'
        ? '''ValidationRule.body($fieldName, $validator, optional: $optional, message: $message)'''
        : '''ValidationRule(location: $location, fieldName: $fieldName, validator: $validator, optional: $optional, message: $message)''';
  }
}
