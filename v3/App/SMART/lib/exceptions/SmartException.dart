// Custom Exceptions for SMART itself
class SmartException implements Exception {
  final String message;

  @override
  String toString() {
    return '[SmartException] -> $message';
  }

  static String get credentialNotFoundException => 'Unable to Fetch Login Credentials.';

  SmartException(this.message);
}