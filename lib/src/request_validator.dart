import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:meta/meta.dart';
import 'package:request_validator/request_validator.dart';

/// The type definition for a [Map]
typedef JsonMap = Map<String, dynamic>;

/// {@template request_validator}
/// A [RequestValidator] represents a component responsible for validating
/// incoming HTTP requests. It defines the rules and behaviour for ensuring
/// that requests adhere to expected format and data structure.
///
/// [RequestValidator] should be extended to define custom [RequestValidator]
/// instances. For example,
///
/// ```dart
/// class PersonValidator extends RequestValidator {
///  PersonValidator() : super(allowedMethods: [HttpMethod.post]);
///
///  @override
///  FutureOr<Response> onError(List<ValidationError> errors) {
///    return Response.json(
///      statusCode: HttpStatus.badRequest,
///      body: errors.toMapArray()
///    );
///  }
///
///  @override
///  List<ValidationRule> validationRules() => [
///        ValidationRule.body('name', (value) => value is String),
///        ValidationRule.body('age', (value) => value is int && value > 0),
///      ];
/// }
/// ```
/// {@endtemplate}
@immutable
abstract class RequestValidator {
  /// {@macro request_validator}
  const RequestValidator({required this.allowedMethods});

  /// List of [HttpMethod]s where the validation will be performed.
  ///
  /// This defines for which HTTP methods (e.g., POST, PUT) the validations
  /// specified in this validator will be applied. If a request with a different
  /// method is received, the validation will be skipped.
  final List<HttpMethod> allowedMethods;

  /// List of [ValidationRule]s to be performed to validate the incoming HTTP
  /// request body.
  ///
  /// This method should return a list of `ValidationRule` objects that define
  /// specific validation logic for different fields within the request body.
  /// The framework will iterate through these rules and perform the
  /// validations on the corresponding fields.
  List<ValidationRule> validationRules();

  /// [Response] object to be sent to the client when the validation
  /// fails due to [ValidationRule]s.
  ///
  /// The `errors` object within the response should contain details
  /// about the validation failures, while a successful validation would result
  /// in an empty error list.
  FutureOr<Response> onError(List<ValidationError> errors);

  /// Provides a default error message when a validation rule fails for a field.
  String defaultErrorMessage(String fieldName) {
    return '''The field '$fieldName' is invalid. Please check the validation rules for this field.''';
  }

  /// Private method that iterates through validation rules to build
  /// a list of [ValidationError] objects when [ValidationRule] fails.
  List<ValidationError> _validateRulesAndFindErrors(JsonMap requestBody) {
    final errors = <ValidationError>[];

    // Iterate through the validation rules
    for (final rule in validationRules()) {
      // Check if the field exists in the Request Body
      final doesFieldExist = requestBody.containsKey(rule.fieldName);
      // Check if the field is optional, then continue if field doesn't exist
      if (!doesFieldExist && rule.optional) continue;
      // If field doesn not exist but field is also not optional, create error
      if (!doesFieldExist && !rule.optional) {
        errors.add(_buildValidationError(rule, null));
        continue;
      }

      // Find the value from request body and validate against validator
      final value = requestBody[rule.fieldName];
      final isValueValidated = rule.validator(value);
      // Create a validation error if the validation is unsuccessful
      if (!isValueValidated) {
        errors.add(_buildValidationError(rule, value));
      }
    }

    return errors;
  }

  /// Returns a [ValidationError] object from [ValidationRule].
  ValidationError _buildValidationError(ValidationRule rule, dynamic value) {
    return ValidationError(
      fieldName: rule.fieldName,
      value: value,
      errorMessage: rule.message ?? defaultErrorMessage(rule.fieldName),
    );
  }

  @override
  bool operator ==(covariant RequestValidator other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;
    return listEquals(other.allowedMethods, allowedMethods);
  }

  @override
  int get hashCode => Object.hashAll([allowedMethods]);
}

/// Extention on [RequestValidator]
extension RequestValidatorX on RequestValidator {
  /// Converts the [RequestValidator] into a middleware function.
  Middleware serveAsMiddleware() {
    return (handler) {
      return (context) async {
        // Find the HTTP Method, and check if it's part of the allowed methods
        final method = context.request.method;
        if (allowedMethods.contains(method)) {
          // Extract the request body object as JSON.
          final requestBody = await context.request.json() as JsonMap;
          // Validate against validation rules and build validation errors
          final validationErrors = _validateRulesAndFindErrors(requestBody);
          // If there's error, return the `onError` Response
          if (validationErrors.isNotEmpty) {
            return onError(validationErrors);
          }
        }
        // Complete the route handler and return the response
        final response = await handler(context);
        return response;
      };
    };
  }
}
