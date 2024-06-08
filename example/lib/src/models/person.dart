// ignore_for_file: public_member_api_docs

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'person.g.dart';

enum Gender {
  male,
  female,
  other;

  String get name => toString().split('.').last;
}

@immutable
@JsonSerializable()
class Person extends Equatable {
  const Person({
    required this.username,
    required this.email,
    required this.age,
    required this.gender,
  });

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);

  final String username;
  final String email;
  final int age;
  final Gender gender;

  Map<String, dynamic> toJson() => _$PersonToJson(this);

  @override
  String toString() =>
      '''Person(username: $username, email: $email, age: $age, gender: $gender)''';

  @override
  List<Object?> get props => [username, email, age, gender];
}
