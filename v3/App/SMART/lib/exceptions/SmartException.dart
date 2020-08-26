// Custom Exceptions for SMART itself
class SmartException implements Exception {
  final String message;
  final String errorCausedBy;

  @override
  String toString() {
    if(errorCausedBy != null)
      return '[SmartException] -> $message - Error Caused By -> [$errorCausedBy]';
    return '[SmartException] -> $message';
  }

  static String get credentialNotFoundException => 'Unable to Fetch Login Credentials.';
  static String get smartIdNotProvidedException => 'SmartID is null or not provided.';
  static String get roomNotProvidedException => 'Room name is null or not provided.';
  static String get appToNodeSwitchStateUpdateException => 'Error while publishing App to Node switch state to MQTT.';

  SmartException(this.message,{this.errorCausedBy});
}