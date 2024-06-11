import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:request_validator/request_validator.dart';

Handler middleware(Handler handler) {
  final validator = QueryValidator();
  return handler.use(validator.serveAsMiddleware());
}

class QueryValidator extends RequestValidator {
  QueryValidator() : super(allowedMethods: [HttpMethod.get]);

  @override
  FutureOr<Response> onError(List<ValidationError> errors) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: errors.toMapArray(),
    );
  }

  @override
  List<ValidationRule> validationRules() => [
        ValidationRule.query(
          'code',
          (value) => int.parse(value) > 100,
          message: 'Please provide valid code to the query.',
        ),
      ];
}
