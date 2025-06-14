import 'package:dio/dio.dart';

final String baseUrl = const String.fromEnvironment("SERVER_URL", defaultValue: "http://localhost:8080");

final dio = Dio(
  BaseOptions(baseUrl: baseUrl),
);