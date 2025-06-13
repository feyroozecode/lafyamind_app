import 'dart:async';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'auth_user';
  static const String _tokenExpiryKey = 'token_expiry';

  // Mock users database
  static const Map<String, String> _mockUsers = {
    'admin@example.com': 'password123',
    'user@test.com': 'test123',
    'demo@lafyamind.com': 'demo123',
  };

  Timer? _tokenExpiryTimer;
  final StreamController<AuthState> _authStateController = StreamController<AuthState>.broadcast();

  Stream<AuthState> get authStateStream => _authStateController.stream;

  AuthService() {
    _initializeAuthState();
  }

  Future<void> _initializeAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    final tokenString = prefs.getString(_tokenKey);
    final userJson = prefs.getString(_userKey);
    final expiryString = prefs.getString(_tokenExpiryKey);

    if (tokenString != null && userJson != null && expiryString != null) {
      try {
        final expiry = DateTime.parse(expiryString);
        if (DateTime.now().isBefore(expiry)) {
          // Token is still valid
          final user = User.fromJson(_parseJsonString(userJson));
          final token = AuthToken(
            token: tokenString,
            createdAt: DateTime.now().subtract(const Duration(minutes: 10)).add(expiry.difference(DateTime.now())),
            expiresAt: expiry,
          );
          
          _startTokenExpiryTimer(token);
          _authStateController.add(AuthState.authenticated(user: user, token: token));
          return;
        } else {
          // Token expired, clear stored data
          await _clearStoredAuth();
        }
      } catch (e) {
        await _clearStoredAuth();
      }
    }

    _authStateController.add(const AuthState.initial());
  }

  Future<AuthState> login(String email, String password) async {
    try {
      _authStateController.add(const AuthState.loading());

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Check mock credentials
      if (!_mockUsers.containsKey(email) || _mockUsers[email] != password) {
        const errorState = AuthState.error(errorMessage: 'Invalid email or password');
        _authStateController.add(errorState);
        return errorState;
      }

      // Create mock user and token
      final user = User(
        id: _generateUserId(),
        email: email,
        name: _extractNameFromEmail(email),
        createdAt: DateTime.now(),
      );

      final token = AuthToken.mock();

      // Store authentication data
      await _storeAuthData(user, token);

      // Start token expiry timer
      _startTokenExpiryTimer(token);

      final authenticatedState = AuthState.authenticated(user: user, token: token);
      _authStateController.add(authenticatedState);
      return authenticatedState;
    } catch (e) {
      final errorState = AuthState.error(errorMessage: 'Login failed: ${e.toString()}');
      _authStateController.add(errorState);
      return errorState;
    }
  }

  Future<void> logout() async {
    try {
      _cancelTokenExpiryTimer();
      await _clearStoredAuth();
      _authStateController.add(const AuthState.initial());
    } catch (e) {
      _authStateController.add(AuthState.error(errorMessage: 'Logout failed: ${e.toString()}'));
    }
  }

  Future<AuthState> refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      
      if (userJson == null) {
        await logout();
        return const AuthState.unauthenticated(errorMessage: 'No user data found');
      }

      final user = User.fromJson(_parseJsonString(userJson));
      final newToken = AuthToken.mock();

      await _storeAuthData(user, newToken);
      _startTokenExpiryTimer(newToken);

      final authenticatedState = AuthState.authenticated(user: user, token: newToken);
      _authStateController.add(authenticatedState);
      return authenticatedState;
    } catch (e) {
      final errorState = AuthState.error(errorMessage: 'Token refresh failed: ${e.toString()}');
      _authStateController.add(errorState);
      return errorState;
    }
  }

  Future<bool> isTokenValid() async {
    final prefs = await SharedPreferences.getInstance();
    final expiryString = prefs.getString(_tokenExpiryKey);
    
    if (expiryString == null) return false;
    
    try {
      final expiry = DateTime.parse(expiryString);
      return DateTime.now().isBefore(expiry);
    } catch (e) {
      return false;
    }
  }

  void _startTokenExpiryTimer(AuthToken token) {
    _cancelTokenExpiryTimer();
    
    final timeUntilExpiry = token.timeUntilExpiry;
    if (timeUntilExpiry.isNegative) {
      // Token already expired
      logout();
      return;
    }

    _tokenExpiryTimer = Timer(timeUntilExpiry, () {
      _authStateController.add(const AuthState.unauthenticated(errorMessage: 'Session expired'));
      logout();
    });
  }

  void _cancelTokenExpiryTimer() {
    _tokenExpiryTimer?.cancel();
    _tokenExpiryTimer = null;
  }

  Future<void> _storeAuthData(User user, AuthToken token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token.token);
    await prefs.setString(_userKey, _jsonStringify(user.toJson()));
    await prefs.setString(_tokenExpiryKey, token.expiresAt.toIso8601String());
  }

  Future<void> _clearStoredAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
    await prefs.remove(_tokenExpiryKey);
  }

  String _generateUserId() {
    final random = Random();
    return 'user_${random.nextInt(999999).toString().padLeft(6, '0')}';
  }

  String _extractNameFromEmail(String email) {
    final username = email.split('@').first;
    return username.split('.').map((part) => 
      part.isEmpty ? '' : part[0].toUpperCase() + part.substring(1)
    ).join(' ');
  }

  Map<String, dynamic> _parseJsonString(String jsonString) {
    // Simple JSON parsing for stored user data
    return <String, dynamic>{
      'id': _extractValueFromJson(jsonString, 'id'),
      'email': _extractValueFromJson(jsonString, 'email'),
      'name': _extractValueFromJson(jsonString, 'name'),
      'createdAt': _extractValueFromJson(jsonString, 'createdAt'),
    };
  }

  String _extractValueFromJson(String jsonString, String key) {
    final pattern = RegExp('"$key":"([^"]*)"');
    final match = pattern.firstMatch(jsonString);
    return match?.group(1) ?? '';
  }

  String _jsonStringify(Map<String, dynamic> json) {
    final buffer = StringBuffer();
    buffer.write('{');
    final entries = json.entries.toList();
    for (int i = 0; i < entries.length; i++) {
      final entry = entries[i];
      buffer.write('"${entry.key}":"${entry.value}"');
      if (i < entries.length - 1) buffer.write(',');
    }
    buffer.write('}');
    return buffer.toString();
  }

  void dispose() {
    _cancelTokenExpiryTimer();
    _authStateController.close();
  }
}