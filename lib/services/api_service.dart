import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import '../models/notice.dart';

/// A problem with an API call, with a message that is safe to show the user.
class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  @override
  String toString() => message;
}

/// All REST communication lives here, so screens never touch http directly.
///
/// Endpoints (base URL https://dummyjson.com):
///   GET  /posts?limit=20                 -> notices
///   GET  /users?limit=0&select=...       -> organizer names
///   POST /posts/add                      -> submit feedback (simulated)
class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const String _baseUrl = 'https://dummyjson.com';
  static const Duration _timeout = Duration(seconds: 15);

  /// Internet connectivity validation: stop early when the device is offline.
  Future<void> _ensureOnline() async {
    final results = await Connectivity().checkConnectivity();
    if (results.contains(ConnectivityResult.none)) {
      throw const ApiException(
        'No internet connection. Check your Wi-Fi or mobile data and try again.',
      );
    }
  }

  /// HTTP GET that returns the decoded JSON object, turning every kind of
  /// failure into an ApiException.
  Future<Map<String, dynamic>> _getJson(Uri uri) async {
    try {
      final response = await _client
          .get(uri, headers: {'Accept': 'application/json'})
          .timeout(_timeout);

      if (response.statusCode != 200) {
        throw ApiException(
          'Server error (${response.statusCode}). Please try again later.',
        );
      }
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw const ApiException('Unexpected response from the server.');
      }
      return decoded;
    } on ApiException {
      rethrow;
    } on TimeoutException {
      throw const ApiException('The server took too long to respond. Please retry.');
    } on http.ClientException {
      throw const ApiException('Could not reach the server. Check your internet connection.');
    } on FormatException {
      throw const ApiException('The server sent data that could not be read.');
    }
  }

  /// Notices (HTTP GET), each combined with its organizer's name.
  Future<List<Notice>> fetchNotices({int limit = 20}) async {
    await _ensureOnline();

    final data = await _getJson(Uri.parse('$_baseUrl/posts?limit=$limit'));
    final posts = data['posts'];
    if (posts is! List) {
      throw const ApiException('Unexpected response from the server.');
    }

    final organizers = await _fetchOrganizers();
    return [
      for (final post in posts.whereType<Map<String, dynamic>>())
        Notice.fromJson(
          post,
          organizer: organizers[post['userId']] ?? 'University Office',
        ),
    ];
  }

  /// userId -> "Name (Department)". If this second call fails, the notices
  /// still load and simply show the default organizer.
  Future<Map<int, String>> _fetchOrganizers() async {
    try {
      final data = await _getJson(
        Uri.parse('$_baseUrl/users?limit=0&select=id,firstName,lastName,company'),
      );
      final users = data['users'];
      if (users is! List) return {};
      final map = <int, String>{};
      for (final user in users.whereType<Map<String, dynamic>>()) {
        final id = (user['id'] as num?)?.toInt();
        if (id == null) continue;
        final name = '${user['firstName'] ?? ''} ${user['lastName'] ?? ''}'.trim();
        final company = user['company'];
        final department = company is Map ? company['department']?.toString() : null;
        if (name.isEmpty) continue;
        map[id] = department == null ? name : '$name ($department)';
      }
      return map;
    } on ApiException {
      return {};
    }
  }

  /// Feedback (HTTP POST with a JSON body). The API only simulates saving and
  /// returns the new record with an id, which is used as a reference number.
  Future<int> submitFeedback({
    required String title,
    required String message,
    int userId = 1,
  }) async {
    await _ensureOnline();
    try {
      final response = await _client
          .post(
            Uri.parse('$_baseUrl/posts/add'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'title': title, 'body': message, 'userId': userId}),
          )
          .timeout(_timeout);

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ApiException(
          'Could not submit feedback (error ${response.statusCode}).',
        );
      }
      final decoded = jsonDecode(response.body);
      return decoded is Map ? (decoded['id'] as num?)?.toInt() ?? 0 : 0;
    } on ApiException {
      rethrow;
    } on TimeoutException {
      throw const ApiException('The server took too long to respond. Please retry.');
    } on http.ClientException {
      throw const ApiException('Could not reach the server. Check your internet connection.');
    } on FormatException {
      throw const ApiException('The server sent data that could not be read.');
    }
  }
}
