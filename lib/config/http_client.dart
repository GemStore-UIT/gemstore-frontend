import 'package:dio/dio.dart';

final String baseUrl = const String.fromEnvironment("SERVER_URL");

final dio = Dio(
  BaseOptions(baseUrl: baseUrl),
);