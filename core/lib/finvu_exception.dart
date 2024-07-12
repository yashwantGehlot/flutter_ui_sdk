class FinvuException implements Exception {
  final int code;
  final String? message;
  FinvuException(this.code, this.message);

  static FinvuException from(e) {
    return FinvuException(int.parse(e.code), e.message);
  }
}
