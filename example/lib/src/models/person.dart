import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'person.g.dart';

/// Enum to represent gender
enum Gender {
  /// Male
  male,

  /// Female
  female,

  /// Other
  other;

  /// Returns the string representation of the enum value
  /// without the class prefix.
  String get name => toString().split('.').last;
}

/// {@template person}
/// A class representing a person with basic information like
/// username, email, age, and gender.
/// {@endtemplate}
@immutable
@JsonSerializable()
class Person extends Equatable {
  /// {@macro person}
  const Person({
    required this.username,
    required this.email,
    required this.age,
    required this.gender,
  });

  /// Creates an instance of [Person] from [Map].
  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);

  /// Username of the person.
  final String username;

  /// Email id of the person.
  final String email;

  /// Age of the person.
  final int age;

  /// Gender of the person
  final Gender gender;

  /// Converts [Person] object to a [Map] onject.
  Map<String, dynamic> toJson() => _$PersonToJson(this);

  @override
  String toString() =>
      '''Person(username: $username, email: $email, age: $age, gender: $gender)''';

  @override
  List<Object?> get props => [username, email, age, gender];
}
