class FinvuFIPInfo {
  FinvuFIPInfo({
    required this.fipId,
    required this.productName,
    required this.fipFitypes,
    required this.productDesc,
    required this.productIconUri,
    required this.enabled,
    this.fipFsr,
  });

  String fipId;
  String? productName;
  List<String> fipFitypes;
  String? fipFsr;
  String? productDesc;
  String? productIconUri;
  bool enabled;
}
