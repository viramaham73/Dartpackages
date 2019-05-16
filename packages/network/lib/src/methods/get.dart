import 'dart:async' show Future;
import 'package:http/http.dart' as http show get, Response;
import 'package:network/src/exception.dart';
import 'package:network/src/response.dart';
import 'package:network/src/utils/response_by_type.dart';
import 'package:network/src/utils/serialize_query_params.dart';

Future<T> get<T extends BinaryResponse>(
  String url, {
  Map<String, String> headers,
  Map<String, dynamic> queryParameters = const {},
}) async {
  final http.Response httpResponse = await http
      .get(url + serializeQueryParameters(queryParameters), headers: headers);

  final int statusCode = httpResponse.statusCode;

  final response = makeResponseByType<T>(statusCode, httpResponse.bodyBytes);

  if (statusCode < 200 || statusCode >= 400) {
    throw NetworkException<T>(response);
  }

  return response;
}
