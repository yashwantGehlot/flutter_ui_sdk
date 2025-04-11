import 'package:equatable/equatable.dart';

final class Identifier extends Equatable {
  const Identifier({
    required this.fiType,
    required this.type,
    required this.category,
    this.value,
  });

  final String fiType;
  final String category;

  // Supported types as per REBIT (v2.1.0) are MOBILE, AADHAR, EMAIL, PAN, DOB, ACCNO, CRN, PPAN, Others
  final String type;

  final String? value;

  Identifier withValue(final String value) {
    return Identifier(
      fiType: fiType,
      type: type,
      category: category,
      value: value,
    );
  }

  @override
  List<Object?> get props => [
        fiType,
        type,
        category,
        value,
      ];
}
