# Request Validator

A middleware to validate request objects before route handler, currently focused with Dart Frog.

[![Build Status][build_status_badge]][build_status_link]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![Package Version][package_version]][package_link]
[![Code Coverage][coverage_badge]](https://github.com/thecodexhub/request-validator/actions)
[![Powered by Mason][mason_badge]][mason_link]
[![License: MIT][license_badge]][license_link]

---

## 🧭 Overview

This library aims to provide functionalities to simplify request objects validation in Dart Frog applications. It allows the definition of custom validation rules for different fields within the request objects, ensuring data integrity and preventing invalid processing.

## 🚧 Installation

Install the following dependency to the `pubspec.yaml` file of your Dart Frog application:

```yaml
dependencies:
  request_validator: ^0.2.0
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

  // Override validator rules to handle validating request body and query params
  @override
  List<ValidationRule> validationRules() => [
        // Validate if the request body contains `name`, and that should be a string
        ValidationRule.body('name', (value) => value is String),
        // Validate if the request query has `code` field, and
        // it's value should be greater than 0.
        ValidationRule.query('code', (value) => int.parse(value) > 0),
        // Validate the request has `Content-Type` header set as `application/json`
        ValidationRule.headers(
          HttpHeaders.contentTypeHeader,
          (value) => value == 'application/json',
        ),
      ];
}
```

#### 📍 <ins>Other Properties of ValidationRule</ins>

- **optional**: Specifies whether the field being validated is optional within the request body. If true, the library first checks if the field exists in the request body. If it's missing, the validation for that field is skipped.
- **message**: Defines a custom error message to be used when the validation for this field fails. If null (the default), a generic error message will be provided during validation failure.

More complete examples with `ValidationRule`

##### 🟠 Request Body Validation

```dart
static final _emailRegExp = RegExp(
  r'^[a-zA-Z\d.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z\d-]+(?:\.[a-zA-Z\d-]+)*$',
);

ValidationRule.body(
  'email',
  (value) => value is String && _emailRegExp.hasMatch(value),
  optional: false,
  message: 'Either the email field is empty or invalid!',
),
```

##### 🟣 Request Query Validation

```dart
ValidationRule.query(
  'filter',
  (value) => ['name', 'age', 'email'].contains(value),
  optional: true,
  message: 'Valid filters are - name, age, and email.',
),
```

##### 🟣 Request Headers Validation

```dart
ValidationRule.headers(
  HttpHeaders.contentTypeHeader,
  (value) => value == 'application/json',
  optional: false,
  message: 'The request must have application/json as content type',
),
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

## 🧩 Example

See the [example][example] Dart Frog app.

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
[build_status_badge]: https://github.com/thecodexhub/request-validator/actions/workflows/main.yaml/badge.svg?branch=main
[build_status_link]: https://github.com/thecodexhub/request-validator/actions
[example]: ./example/
[package_version]: https://img.shields.io/pub/v/request_validator.svg
[package_link]: https://pub.dev/packages/request_validator
