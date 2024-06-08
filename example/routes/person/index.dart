import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:example/models.dart';

FutureOr<Response> onRequest(RequestContext context) {
  switch (context.request.method) {
    case HttpMethod.post:
      return _postMethod(context);
    case HttpMethod.get:
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.put:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

FutureOr<Response> _postMethod(RequestContext context) async {
  final requestBody = await context.request.json() as Map<String, dynamic>;
  final person = Person.fromJson(requestBody);
  return Response.json(body: person.toJson());
}
