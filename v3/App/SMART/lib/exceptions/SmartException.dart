// Custom Exceptions for SMART itself
class SmartException implements Exception {
  final String message;

  @override
  String toString() {
    return '[SmartException] -> $message';
  }

  static String get credentialNotFoundException => 'Unable to Fetch Login Credentials.';
  static String get smartIdNotProvided => 'SmartID is null or not provided.';
  static String get roomNotProvided => 'Room name is null or not provided.';

  SmartException(this.message);
}