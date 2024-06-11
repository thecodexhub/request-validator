import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

FutureOr<Response> onRequest(RequestContext context, String id) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _getMethod(context, id);
    case HttpMethod.post:
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.put:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

FutureOr<Response> _getMethod(RequestContext context, String id) async {
  final queryParams = context.request.url.queryParameters;
  return Response.json(
    body: <String, dynamic>{
      'id': id,
      'code': queryParams['code'],
    },
  );
}
