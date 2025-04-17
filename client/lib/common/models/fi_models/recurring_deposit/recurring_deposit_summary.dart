import 'package:xml/xml.dart';

class RecurringDepositSummary {
  String? accountType;
  String? openingDate;
  String? branch;
  String? ifsc;
  String? maturityAmount;
  String? maturityDate;
  String? description;
  String? interestPayout;
  String? interestRate;
  String? principalAmount;
  String? tenureDays;
  String? tenureMonths;
  String? tenureYears;
  String? recurringAmount;
  String? recurringDepositDay;
  String? interestComputation;
  String? compoundingFrequency;
  String? interestPeriodicPayoutAmount;
  String? interestOnMaturity;
  String? currentValue;

  RecurringDepositSummary({
    this.accountType,
    this.openingDate,
    this.branch,
    this.ifsc,
    this.maturityAmount,
    this.maturityDate,
    this.description,
    this.interestPayout,
    this.interestRate,
    this.principalAmount,
    this.tenureDays,
    this.tenureMonths,
    this.tenureYears,
    this.recurringAmount,
    this.recurringDepositDay,
    this.interestComputation,
    this.compoundingFrequency,
    this.interestPeriodicPayoutAmount,
    this.interestOnMaturity,
    this.currentValue,
  });

  factory RecurringDepositSummary.fromXmlElement(
      final XmlElement summaryElement) {
    return RecurringDepositSummary(
      accountType: summaryElement.getAttribute('accountType'),
      openingDate: summaryElement.getAttribute('openingDate'),
      branch: summaryElement.getAttribute('branch'),
      ifsc: summaryElement.getAttribute('ifsc'),
      maturityAmount: summaryElement.getAttribute('maturityAmount'),
      maturityDate: summaryElement.getAttribute('maturityDate'),
      description: summaryElement.getAttribute('description'),
      interestPayout: summaryElement.getAttribute('interestPayout'),
      interestRate: summaryElement.getAttribute('interestRate'),
      principalAmount: summaryElement.getAttribute('principalAmount'),
      tenureDays: summaryElement.getAttribute('tenureDays'),
      tenureMonths: summaryElement.getAttribute('tenureMonths'),
      tenureYears: summaryElement.getAttribute('tenureYears'),
      recurringAmount: summaryElement.getAttribute('recurringAmount'),
      recurringDepositDay: summaryElement.getAttribute('recurringDepositDay'),
      interestComputation: summaryElement.getAttribute('interestComputation'),
      compoundingFrequency: summaryElement.getAttribute('compoundingFrequency'),
      interestPeriodicPayoutAmount:
          summaryElement.getAttribute('interestPeriodicPayoutAmount'),
      interestOnMaturity: summaryElement.getAttribute('interestOnMaturity'),
      currentValue: summaryElement.getAttribute('currentValue'),
    );
  }
}
