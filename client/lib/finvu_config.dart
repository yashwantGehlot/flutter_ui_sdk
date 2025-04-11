class FinvuConfig {
  FinvuConfig({
    required this.finvuEndpoint,
    this.certificatePins,
  });
  String finvuEndpoint;
  List<String>? certificatePins;
}
