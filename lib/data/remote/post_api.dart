import 'dart:convert';
import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:utsav_beladiya/models/post.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  ApiException(this.message, {this.statusCode});
  @override
  String toString() => 'ApiException($statusCode): $message';
}

class PostApi {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';



  Future<List<Post>> fetchPosts() async {
    final uri = Uri.parse('$baseUrl/posts');
    try {
      final resp = await http
          .get(uri, headers: {HttpHeaders.acceptHeader: 'application/json'})
          .timeout(const Duration(seconds: 10));

      if (resp.statusCode != 200) {
        throw ApiException('Failed to load posts', statusCode: resp.statusCode);
      }
      return List<Post>.from(json.decode(resp.body).map((x) => Post.fromJson(x)));
     
    } on SocketException {
      throw ApiException('No internet connection');
    } on HttpException {
      throw ApiException('HTTP error occurred');
    } on FormatException {
      throw ApiException('Bad response format');
    } on TimeoutException {
      throw ApiException('Request timed out');
    }
  }

  Future<Post> fetchPostDetail(int id) async {
    final uri = Uri.parse('$baseUrl/posts/$id');
    log('fetchPostDetail: $uri');
    try {
      final resp = await http
          .get(uri, headers: {HttpHeaders.acceptHeader: 'application/json'})
          .timeout(const Duration(seconds: 10));

      if (resp.statusCode != 200) {
        throw ApiException('Failed to load post', statusCode: resp.statusCode);
      }
      return Post.fromJson(json.decode(resp.body));
    } on SocketException {
      throw ApiException('No internet connection');
    } on HttpException {
      throw ApiException('HTTP error occurred');
    } on FormatException {
      throw ApiException('Bad response format');
    } on TimeoutException {
      throw ApiException('Request timed out');
    }
  }
}


