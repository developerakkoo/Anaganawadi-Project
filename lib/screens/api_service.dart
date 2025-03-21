import 'package:dio/dio.dart';

class ApiService {
  // Singleton instance
  static final ApiService _instance = ApiService._internal();
  final Dio _dio = Dio();
  String? token; // Store the Bearer token

  // Base URL for the API
  static const String _baseUrl = 'http://192.168.208.246:8080';

  // Private constructor for singleton
  ApiService._internal() {
    // Initialize Dio options
    _dio.options.baseUrl = _baseUrl;
    _dio.options.headers = {
      'Content-Type': 'application/json',
    };
  }

  // Factory constructor to return the singleton instance
  factory ApiService() {
    return _instance;
  }

  // Method to set the Bearer token
  void setToken(String token) {
    this.token = token;
    _dio.options.headers['Authorization'] = 'Bearer $token';
    print("Token set in headers: ${_dio.options.headers}"); // Debug log
  }

  // Method to register staff
  Future<void> registerStaff(Map<String, dynamic> staffData) async {
    try {
      final response = await _dio.post(
        '/api/auth/register/staffs',
        data: staffData,
      );

      if (response.statusCode == 200) {
        print("Staff registered successfully!");
      } else {
        print("Failed to register staff: ${response.statusMessage}");
        print("Response data: ${response.data}");
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print("Error response data: ${e.response?.data}");
        print("Error response status: ${e.response?.statusCode}");
        print("Error response headers: ${e.response?.headers}");
      } else {
        print("Error: ${e.message}");
      }
      rethrow;
    } catch (e) {
      print("Error registering staff: $e");
      rethrow;
    }
  }

  // Method to register family
  Future<void> registerFamily(Map<String, dynamic> familyData) async {
    try {
      final response = await _dio.post(
        '/api/auth/register/family',
        data: familyData,
      );

      if (response.statusCode == 200) {
        print("Family registered successfully!");
      } else {
        print("Failed to register family: ${response.statusMessage}");
        print("Response data: ${response.data}");
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print("Error response data: ${e.response?.data}");
        print("Error response status: ${e.response?.statusCode}");
        print("Error response headers: ${e.response?.headers}");
      } else {
        print("Error: ${e.message}");
      }
      rethrow;
    } catch (e) {
      print("Error registering family: $e");
      rethrow;
    }
  }

  // Method to submit activity data
  Future<void> activitySection(Map<String, dynamic> activityData) async {
    try {
      // Ensure the token is set
      if (token == null || token!.isEmpty) {
        throw Exception("Authentication token is missing.");
      }

      final response = await _dio.post(
        '/api/dashboard/activities/schedule/create',
        data: activityData,
      );

      if (response.statusCode == 200) {
        print("Activity registered successfully!");
      } else {
        print("Failed to register Activity: ${response.statusMessage}");
        print("Response data: ${response.data}");
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print("Error response data: ${e.response?.data}");
        print("Error response status: ${e.response?.statusCode}");
        print("Error response headers: ${e.response?.headers}");
      } else {
        print("Error: ${e.message}");
      }
      rethrow;
    } catch (e) {
      print("Error registering Activity: $e");
      rethrow;
    }
  }

  // Method to submit Guide data
  Future<void> activityGuide(Map<String, dynamic> activityData) async {
    try {
      // Ensure the token is set
      if (token == null || token!.isEmpty) {
        throw Exception("Authentication token is missing.");
      }

      final response = await _dio.post(
        '/api/dashboard/activities/guides/create',
        data: activityData,
      );

      if (response.statusCode == 200) {
        print("Guide registered successfully!");
      } else {
        print("Failed to register Guide: ${response.statusMessage}");
        print("Response data: ${response.data}");
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print("Error response data: ${e.response?.data}");
        print("Error response status: ${e.response?.statusCode}");
        print("Error response headers: ${e.response?.headers}");
      } else {
        print("Error: ${e.message}");
      }
      rethrow;
    } catch (e) {
      print("Error registering Guide: $e");
      rethrow;
    }
  }

  // Child
  Future<void> registerChild(Map<String, dynamic> staffData) async {
    try {
      final response = await _dio.post(
        '/api/auth/register/family/child?familyId=1&parentIds=1',
        data: staffData,
      );

      if (response.statusCode == 200) {
        print("Child registered successfully!");
      } else {
        print("Failed to register Child: ${response.statusMessage}");
        print("Response data: ${response.data}");
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print("Error response data: ${e.response?.data}");
        print("Error response status: ${e.response?.statusCode}");
        print("Error response headers: ${e.response?.headers}");
      } else {
        print("Error: ${e.message}");
      }
      rethrow;
    } catch (e) {
      print("Error registering Child: $e");
      rethrow;
    }
  }

}