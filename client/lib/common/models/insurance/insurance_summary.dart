import 'package:finvu_flutter_sdk/common/models/insurance/insurance_contract_clause.dart';
import 'package:finvu_flutter_sdk/common/models/insurance/insurance_cover.dart';
import 'package:finvu_flutter_sdk/common/models/insurance/insurance_money_back.dart';
import 'package:xml/xml.dart';

class InsuranceSummary {
  String? policyName;
  String? policyNumber;
  String? eiaNumber;
  String? policyDescription;
  double? sumAssured;
  double? coverAmount;
  int? tenureMonths;
  int? tenureYears;
  double? premiumAmount;
  DateTime? policyStartDate;
  DateTime? policyExpiryDate;
  String? policyType;
  String? coverType;
  String? premiumFrequency;
  int? premiumPaymentYears;
  int? premiumPaymentMonths;
  DateTime? nextPremiumDueDate;
  DateTime? maturityDate;
  double? maturityBenifit;

  List<InsuranceMoneyBack> insuranceMoneyBacks;
  List<InsuranceContractClause> insuranceContractClauses;
  List<InsuranceCover> insuranceCovers;

  InsuranceSummary({
    required this.policyName,
    required this.policyNumber,
    required this.eiaNumber,
    required this.policyDescription,
    required this.sumAssured,
    required this.coverAmount,
    required this.tenureMonths,
    required this.tenureYears,
    required this.premiumAmount,
    required this.policyStartDate,
    required this.policyExpiryDate,
    required this.policyType,
    required this.coverType,
    required this.premiumFrequency,
    required this.premiumPaymentYears,
    required this.premiumPaymentMonths,
    required this.nextPremiumDueDate,
    required this.maturityDate,
    required this.maturityBenifit,
    required this.insuranceMoneyBacks,
    required this.insuranceContractClauses,
    required this.insuranceCovers,
  });

  factory InsuranceSummary.fromXmlElement(
      final XmlElement insuranceSummaryElement) {
    final moneyBacksElement =
        insuranceSummaryElement.findElements('MoneyBacks').first;
    final contractClausesElement =
        insuranceSummaryElement.findElements('ContractClauses').first;
    final coversElement = insuranceSummaryElement.findElements('Covers').first;

    final moneyBacks = moneyBacksElement
        .findElements("MoneyBack")
        .map((element) => InsuranceMoneyBack.fromXmlElement(element))
        .toList();
    final contractClauses = contractClausesElement
        .findElements("ContractClause")
        .map((element) => InsuranceContractClause.fromXmlElement(element))
        .toList();
    final insuranceCovers = coversElement
        .findElements("Cover")
        .map((element) => InsuranceCover.fromXmlElement(element))
        .toList();

    final policyStartDateString =
        insuranceSummaryElement.getAttribute("policyStartDate");
    final policyExpiryDateString =
        insuranceSummaryElement.getAttribute("policyExpiryDate");
    final nextPremiumDueDateString =
        insuranceSummaryElement.getAttribute("nextPremiumDueDate");
    final maturityDateString =
        insuranceSummaryElement.getAttribute("maturityDate");

    return InsuranceSummary(
      insuranceMoneyBacks: moneyBacks,
      insuranceContractClauses: contractClauses,
      insuranceCovers: insuranceCovers,
      policyName: insuranceSummaryElement.getAttribute('policyName'),
      policyNumber: insuranceSummaryElement.getAttribute('policyNumber'),
      eiaNumber: insuranceSummaryElement.getAttribute('eiaNumber'),
      policyDescription:
          insuranceSummaryElement.getAttribute('policyDescription'),
      sumAssured: double.tryParse(
          insuranceSummaryElement.getAttribute("sumAssured") ?? "0.0"),
      coverAmount: double.tryParse(
          insuranceSummaryElement.getAttribute("coverAmount") ?? "0.0"),
      tenureMonths: int.tryParse(
          insuranceSummaryElement.getAttribute("tenureMonths") ?? "0"),
      tenureYears: int.tryParse(
          insuranceSummaryElement.getAttribute("tenureYears") ?? "0"),
      premiumAmount: double.tryParse(
          insuranceSummaryElement.getAttribute("premiumAmount") ?? "0.0"),
      policyStartDate: policyStartDateString != null
          ? DateTime.parse(policyStartDateString)
          : null,
      policyExpiryDate: policyExpiryDateString != null
          ? DateTime.parse(policyExpiryDateString)
          : null,
      policyType: insuranceSummaryElement.getAttribute('policyType'),
      coverType: insuranceSummaryElement.getAttribute('coverType'),
      premiumFrequency:
          insuranceSummaryElement.getAttribute('premiumFrequency'),
      premiumPaymentYears: int.tryParse(
          insuranceSummaryElement.getAttribute("premiumPaymentYears") ?? "0"),
      premiumPaymentMonths: int.tryParse(
          insuranceSummaryElement.getAttribute("premiumPaymentMonths") ?? "0"),
      nextPremiumDueDate: nextPremiumDueDateString != null
          ? DateTime.parse(nextPremiumDueDateString)
          : null,
      maturityDate: maturityDateString != null
          ? DateTime.parse(maturityDateString)
          : null,
      maturityBenifit: double.tryParse(
          insuranceSummaryElement.getAttribute("maturityBenifit") ?? "0.0"),
    );
  }
}
