import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:example/models.dart';
import 'package:request_validator/request_validator.dart';

Handler middleware(Handler handler) {
  const validator = PersonValidator(allowedMethods: [HttpMethod.post]);
  return handler.use(requestLogger()).use(validator.serveAsMiddleware());
}

class PersonValidator extends RequestValidator {
  const PersonValidator({required super.allowedMethods});

  static final _emailRegExp = RegExp(
    r'^[a-zA-Z\d.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z\d-]+(?:\.[a-zA-Z\d-]+)*$',
  );

  @override
  FutureOr<Response> onError(List<ValidationError> errors) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: errors.toMapArray(),
    );
  }

  @override
  List<ValidationRule> validationRules() => [
        ValidationRule.body(
          'username',
          (value) => value is String && value.isNotEmpty,
          message: 'Username should be a string and can not be empty.',
        ),
        ValidationRule.body(
          'age',
          (value) => value is int && value > 0,
          message: 'Age should be an integer and greater than zero.',
        ),
        ValidationRule.body(
          'email',
          (value) => value is String && _emailRegExp.hasMatch(value),
          message: 'Email is invalid!',
        ),
        ValidationRule.body(
          'gender',
          (value) =>
              value is String &&
              Gender.values.map((g) => g.name).toList().contains(value),
          message: 'Gender should be either male or female or other',
        ),
      ];
}
