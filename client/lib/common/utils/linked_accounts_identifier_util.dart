class LinkedAccountsIdentifierUtil {
  String generateAccountIdentifier({
    required String fiType,
    required String maskedAccountNumber,
    required String accountType,
  }) {
    return '${fiType}_${maskedAccountNumber.substring(maskedAccountNumber.length - 4)}_${accountType}';
  }
}
