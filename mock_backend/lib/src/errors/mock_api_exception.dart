/// A predictable error shape for the in-memory mock and future HTTP adapter.
class MockApiException implements Exception {
  MockApiException({
    required this.statusCode,
    required this.code,
    required this.message,
    Map<String, List<String>> fieldErrors = const {},
  }) : fieldErrors = Map<String, List<String>>.unmodifiable(
         fieldErrors.map<String, List<String>>(
           (field, messages) => MapEntry<String, List<String>>(
             field,
             List<String>.unmodifiable(messages),
           ),
         ),
       );

  /// Provisional HTTP mapping for a future transport adapter.
  final int statusCode;
  final String code;
  final String message;
  final Map<String, List<String>> fieldErrors;

  Map<String, Object?> toJson() => {
    'code': code,
    'message': message,
    'fieldErrors': fieldErrors,
  };

  @override
  String toString() => 'MockApiException($statusCode, $code): $message';
}
