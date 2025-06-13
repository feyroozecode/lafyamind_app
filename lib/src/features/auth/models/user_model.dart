class User {
  final String id;
  final String email;
  final String name;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.id == id &&
        other.email == email &&
        other.name == name &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^ email.hashCode ^ name.hashCode ^ createdAt.hashCode;
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, name: $name, createdAt: $createdAt)';
  }
}

class AuthToken {
  final String token;
  final DateTime expiresAt;
  final DateTime createdAt;

  const AuthToken({
    required this.token,
    required this.expiresAt,
    required this.createdAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  
  Duration get timeUntilExpiry => expiresAt.difference(DateTime.now());

  factory AuthToken.mock() {
    final now = DateTime.now();
    return AuthToken(
      token: 'mock_token_${now.millisecondsSinceEpoch}',
      createdAt: now,
      expiresAt: now.add(const Duration(minutes: 10)), // Expires after 10 minutes
    );
  }

  factory AuthToken.fromJson(Map<String, dynamic> json) {
    return AuthToken(
      token: json['token'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'expiresAt': expiresAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  AuthToken copyWith({
    String? token,
    DateTime? expiresAt,
    DateTime? createdAt,
  }) {
    return AuthToken(
      token: token ?? this.token,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthToken &&
        other.token == token &&
        other.expiresAt == expiresAt &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return token.hashCode ^ expiresAt.hashCode ^ createdAt.hashCode;
  }

  @override
  String toString() {
    return 'AuthToken(token: $token, expiresAt: $expiresAt, createdAt: $createdAt)';
  }
}

enum AuthStatus {
  authenticated,
  unauthenticated,
  loading,
  error,
}

class AuthState {
  final AuthStatus status;
  final User? user;
  final AuthToken? token;
  final String? errorMessage;

  const AuthState({
    required this.status,
    this.user,
    this.token,
    this.errorMessage,
  });

  const AuthState.initial()
      : status = AuthStatus.unauthenticated,
        user = null,
        token = null,
        errorMessage = null;

  const AuthState.loading()
      : status = AuthStatus.loading,
        user = null,
        token = null,
        errorMessage = null;

  const AuthState.authenticated({
    required User user,
    required AuthToken token,
  })  : status = AuthStatus.authenticated,
        user = user,
        token = token,
        errorMessage = null;

  const AuthState.unauthenticated({String? errorMessage})
      : status = AuthStatus.unauthenticated,
        user = null,
        token = null,
        errorMessage = errorMessage;

  const AuthState.error({required String errorMessage})
      : status = AuthStatus.error,
        user = null,
        token = null,
        errorMessage = errorMessage;

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isLoading => status == AuthStatus.loading;
  bool get hasError => status == AuthStatus.error;
  bool get isTokenExpired => token?.isExpired ?? true;

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    AuthToken? token,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      token: token ?? this.token,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthState &&
        other.status == status &&
        other.user == user &&
        other.token == token &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode {
    return status.hashCode ^ user.hashCode ^ token.hashCode ^ errorMessage.hashCode;
  }

  @override
  String toString() {
    return 'AuthState(status: $status, user: $user, token: $token, errorMessage: $errorMessage)';
  }
}