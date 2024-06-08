# Request Validator

A middleware to validate request body before route handler, currently focused with Dart Frog.

[![Build Status][build_status_badge]][build_status_link]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![Code Coverage][coverage_badge]](https://github.com/thecodexhub/request-validator/actions)
[![Powered by Mason][mason_badge]][mason_link]
[![License: MIT][license_badge]][license_link]

---

## 🧭 Overview

The goal of this library is to provide functionalities to simplify request body validation in Dart Frog applications. It allows to define custom validation rules for different fields within the request body, ensuring data integrity and preventing invalid processing.

## 🚧 Installation

Install the following dependency to the `pubspec.yaml` file of your Dart Frog application:

```yaml
dependencies:
  request_validator: ^0.1.0
```

## 💻 Usage

### 🛠️ Create a RequestValidator

```dart
import 'package:request_validator/request_validator.dart';

// Extend the [RequestValidator] and provide the list of validation rules
// and configure the Response on validation failure.
class PersonValidator extends RequestValidator {
  // Validation rules will work only for POST requests
  PersonValidator() : super(allowedMethods: [HttpMethod.post]);

  // Override onError to configure Response object when validation fails
  @override
  FutureOr<Response> onError(List<ValidationError> errors) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: errors.toMapArray()
    );
  }

  // Override validator rules to handle validating request body object
  @override
  List<ValidationRule> validationRules() => [
        ValidationRule.body('name', (value) => value is String),
        ValidationRule.body('age', (value) => value is int && value > 0),
      ];
}
```

### 📦 Use PersonValidator as Middleware

```dart
Handler middleware(Handler handler) {
  final validator = PersonValidator();
  // The serveAsMiddleware extension on the validator converts it into 
  // a middleware function
  return handler.use(validator.serveAsMiddleware());
}
```

## ✨ Maintainers

- [Sandip Pramanik (thecodexhub)][thecodexhub]

[thecodexhub]: https://github.com/thecodexhub
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[mason_badge]: https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge
[mason_link]: https://github.com/felangel/mason
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[coverage_badge]: https://raw.githubusercontent.com/thecodexhub/request-validator/main/coverage_badge.svg
[build_status_badge]: https://github.com/thecodexhub/request-validator/workflows/ci/badge.svg
[build_status_link]: https://github.com/thecodexhub/request-validator/actions
