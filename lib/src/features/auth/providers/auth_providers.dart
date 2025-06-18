import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import 'auth_service.dart';

// Auth Service Provider
final authServiceProvider = Provider<AuthService>((ref) {
  final service = AuthService();
  ref.onDispose(() => service.dispose());
  return service;
});

// Auth State Provider
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(const AuthState.initial()) {
    _init();
  }

  void _init() {
    _authService.authStateStream.listen((authState) {
      if (mounted) {
        state = authState;
      }
    });
  }

  Future<void> login(String email, String password) async {
    final result = await _authService.login(email, password);
    state = result;
  }

  Future<void> logout() async {
    await _authService.logout();
    state = const AuthState.initial();
  }

  Future<void> refreshToken() async {
    final result = await _authService.refreshToken();
    state = result;
  }

  Future<bool> isTokenValid() async {
    return await _authService.isTokenValid();
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});

// Current User Provider
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.user;
});

// Is Authenticated Provider
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.isAuthenticated && !authState.isTokenExpired;
});

// Auth Token Provider
final authTokenProvider = Provider<AuthToken?>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.token;
});

// Token Expiry Time Provider
final tokenTimeRemainingProvider = Provider<Duration?>((ref) {
  final token = ref.watch(authTokenProvider);
  if (token == null || token.isExpired) return null;
  return token.timeUntilExpiry;
});

// Auth Error Message Provider
final authErrorMessageProvider = Provider<String?>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.errorMessage;
});

// Loading State Provider
final isAuthLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.isLoading;
});

// Login Form State Provider
class LoginFormNotifier extends StateNotifier<LoginFormState> {
  LoginFormNotifier() : super(const LoginFormState());

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  void toggleRememberMe() {
    state = state.copyWith(rememberMe: !state.rememberMe);
  }

  void clearForm() {
    state = const LoginFormState();
  }

  bool validateForm() {
    final emailValid = state.email.isNotEmpty && state.email.contains('@');
    final passwordValid = state.password.isNotEmpty && state.password.length >= 6;
    
    state = state.copyWith(
      emailError: emailValid ? null : 'Please enter a valid email',
      passwordError: passwordValid ? null : 'Password must be at least 6 characters',
    );
    
    return emailValid && passwordValid;
  }
}

final loginFormNotifierProvider = StateNotifierProvider<LoginFormNotifier, LoginFormState>((ref) {
  return LoginFormNotifier();
});

// Login Form State Model
class LoginFormState {
  final String email;
  final String password;
  final bool isPasswordVisible;
  final bool rememberMe;
  final String? emailError;
  final String? passwordError;

  const LoginFormState({
    this.email = '',
    this.password = '',
    this.isPasswordVisible = false,
    this.rememberMe = false,
    this.emailError,
    this.passwordError,
  });

  LoginFormState copyWith({
    String? email,
    String? password,
    bool? isPasswordVisible,
    bool? rememberMe,
    String? emailError,
    String? passwordError,
  }) {
    return LoginFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      rememberMe: rememberMe ?? this.rememberMe,
      emailError: emailError ?? this.emailError,
      passwordError: passwordError ?? this.passwordError,
    );
  }

  bool get isValid => 
    email.isNotEmpty && 
    email.contains('@') && 
    password.isNotEmpty && 
    password.length >= 6;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LoginFormState &&
        other.email == email &&
        other.password == password &&
        other.isPasswordVisible == isPasswordVisible &&
        other.rememberMe == rememberMe &&
        other.emailError == emailError &&
        other.passwordError == passwordError;
  }

  @override
  int get hashCode {
    return email.hashCode ^
        password.hashCode ^
        isPasswordVisible.hashCode ^
        rememberMe.hashCode ^
        emailError.hashCode ^
        passwordError.hashCode;
  }
}

// Demo Credentials Provider (for testing)
final demoCredentialsProvider = Provider<Map<String, String>>((ref) {
  return const {
    'admin@example.com': 'password123',
    'user@test.com': 'test123',
    'demo@lafyamind.com': 'demo123',
  };
});

// Session Timer Provider - tracks remaining session time
final sessionTimerProvider = StreamProvider<Duration?>((ref) async* {
  final token = ref.watch(authTokenProvider);
  
  if (token == null || token.isExpired) {
    yield null;
    return;
  }

  while (true) {
    final remaining = token.timeUntilExpiry;
    if (remaining.isNegative) {
      yield null;
      break;
    }
    yield remaining;
    await Future.delayed(const Duration(seconds: 1));
  }
});