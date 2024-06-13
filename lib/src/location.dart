/// {@template location}
/// Represents the location within the request object where a field
/// was retrieved from.
///
/// This enum is used to identify the source of a field during validation,
/// providing context for error messages and potential security considerations.
/// {@endtemplate}
enum Location {
  /// Indicates the field was extracted from the request body.
  body('BODY'),

  /// Indicates the field was extracted from the request header.
  headers('HEADERS'),

  /// Indicates the field was extracted from the request query parameters.
  query('QUERY');

  /// {@macro location}
  const Location(this.value);

  /// The string representation of the location (e.g., "BODY", "QUERY").
  final String value;
}
