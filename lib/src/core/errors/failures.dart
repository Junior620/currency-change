/// Application failure types
sealed class AppFailure {
  const AppFailure(this.message);
  final String message;
}

class NetworkFailure extends AppFailure {
  const NetworkFailure([String message = 'Network error occurred']) : super(message);
}

class ParseFailure extends AppFailure {
  const ParseFailure([String message = 'Failed to parse data']) : super(message);
}

class RateLimitFailure extends AppFailure {
  const RateLimitFailure([String message = 'Rate limit exceeded']) : super(message);
}

class CacheFailure extends AppFailure {
  const CacheFailure([String message = 'Cache error']) : super(message);
}

class UnknownFailure extends AppFailure {
  const UnknownFailure([String message = 'Unknown error occurred']) : super(message);
}

