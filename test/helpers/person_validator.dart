import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:request_validator/request_validator.dart';

class PersonValidator extends RequestValidator {
  PersonValidator() : super(allowedMethods: [HttpMethod.post]);

  @override
  FutureOr<Response> onError(List<ValidationError> errors) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: errors.toMapArray(),
    );
  }

  @override
  List<ValidationRule> validationRules() => [
        ValidationRule.body('name', (value) => value is String),
        ValidationRule.body('age', (value) => value is int && value > 0),
      ];
}
