import 'package:xml/xml.dart';

class TermDepositSummary {
  String? openingDate;
  String? accountType;
  String? branch;
  String? ifsc;
  String? maturityAmount;
  String? description;
  String? interestPayout;
  String? interestRate;
  String? maturityDate;
  String? principalAmount;
  String? tenureDays;
  String? tenureMonths;
  String? tenureYears;
  String? interestComputation;
  String? compoundingFrequency;
  String? interestPeriodicPayoutAmount;
  String? interestOnMaturity;
  String? currentValue;

  TermDepositSummary({
    this.openingDate,
    this.accountType,
    this.branch,
    this.ifsc,
    this.maturityAmount,
    this.description,
    this.interestPayout,
    this.interestRate,
    this.maturityDate,
    this.principalAmount,
    this.tenureDays,
    this.tenureMonths,
    this.tenureYears,
    this.interestComputation,
    this.compoundingFrequency,
    this.interestPeriodicPayoutAmount,
    this.interestOnMaturity,
    this.currentValue,
  });

  factory TermDepositSummary.fromXmlElement(final XmlElement summaryElement) {
    return TermDepositSummary(
      openingDate: summaryElement.getAttribute('openingDate'),
      accountType: summaryElement.getAttribute('accountType'),
      branch: summaryElement.getAttribute('branch'),
      ifsc: summaryElement.getAttribute('ifsc'),
      maturityAmount: summaryElement.getAttribute('maturityAmount'),
      description: summaryElement.getAttribute('description'),
      interestPayout: summaryElement.getAttribute('interestPayout'),
      interestRate: summaryElement.getAttribute('interestRate'),
      maturityDate: summaryElement.getAttribute('maturityDate'),
      principalAmount: summaryElement.getAttribute('principalAmount'),
      tenureDays: summaryElement.getAttribute('tenureDays'),
      tenureMonths: summaryElement.getAttribute('tenureMonths'),
      tenureYears: summaryElement.getAttribute('tenureYears'),
      interestComputation: summaryElement.getAttribute('interestComputation'),
      compoundingFrequency: summaryElement.getAttribute('compoundingFrequency'),
      interestPeriodicPayoutAmount:
          summaryElement.getAttribute('interestPeriodicPayoutAmount'),
      interestOnMaturity: summaryElement.getAttribute('interestOnMaturity'),
      currentValue: summaryElement.getAttribute('currentValue'),
    );
  }
}
