class GenerationError implements Exception {
  final String message;

  GenerationError(this.message);

  @override
  String toString() {
    return 'GenerationError: $message';
  }
}
