import 'package:xml/xml.dart';

class InsuranceRider {
  String? riderType;
  double? sumAssured;
  int? tenureYears;
  int? tenureMonths;
  double? premiumAmount;
  DateTime? policyStartDate;
  DateTime? policyEndDate;

  InsuranceRider({
    required this.riderType,
    required this.sumAssured,
    required this.tenureYears,
    required this.tenureMonths,
    required this.premiumAmount,
    required this.policyStartDate,
    required this.policyEndDate,
  });

  factory InsuranceRider.fromXmlElement(final XmlElement riderElement) {
    final policyStartDateString = riderElement.getAttribute("policyStartDate");
    final policyEndDateString = riderElement.getAttribute("policyEndDate");

    return InsuranceRider(
      riderType: riderElement.getAttribute("riderType"),
      sumAssured: double.tryParse(riderElement.getAttribute("sumAssured") ?? "0.0"),
      tenureYears: int.tryParse(riderElement.getAttribute("tenureYears") ?? "0"),
      tenureMonths: int.tryParse(riderElement.getAttribute("tenureMonths") ?? "0"),
      premiumAmount: double.tryParse(riderElement.getAttribute("premiumAmount") ?? "0.0"),
      policyStartDate: policyStartDateString != null
          ? DateTime.parse(policyStartDateString)
          : null,
      policyEndDate: policyEndDateString != null
          ? DateTime.parse(policyEndDateString)
          : null,
    );
  }
}
