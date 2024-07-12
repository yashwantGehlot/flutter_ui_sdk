class FinvuFIPDetails {
  FinvuFIPDetails({
    required this.fipId,
    required this.typeIdentifiers,
  });
  String fipId;
  List<FinvuFIPFiTypeIdentifier> typeIdentifiers;
}

class FinvuFIPFiTypeIdentifier {
  FinvuFIPFiTypeIdentifier({
    required this.fiType,
    required this.identifiers,
  });
  String fiType;
  List<FinvuTypeIdentifier> identifiers;
}

class FinvuTypeIdentifier {
  FinvuTypeIdentifier({
    required this.type,
    required this.category,
  });
  String type;
  String category;
}

class FinvuTypeIdentifierInfo {
  FinvuTypeIdentifierInfo({
    required this.category,
    required this.type,
    required this.value,
  });
  String category;
  String type;
  String value;
}
