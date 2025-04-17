import 'package:xml/xml.dart';

class InsuranceContractClause {
  String? title;
  String? description;
  String? conditions;
  String? exclusions;
  double? subLimit;
  double? amount;


  InsuranceContractClause({
    this.title,
    this.description,
    this.subLimit,
    this.amount,
    this.conditions,
    this.exclusions,
  });

  factory InsuranceContractClause.fromXmlElement(
    final XmlElement transactionElement,
  ) {
    return InsuranceContractClause(
      title: transactionElement.getAttribute("title"),
      description: transactionElement.getAttribute("description"),
      conditions: transactionElement.getAttribute("conditions"),
      exclusions: transactionElement.getAttribute("exclusions"),
      subLimit: double.tryParse(transactionElement.getAttribute("subLimit") ?? "0.0"),
      amount: double.tryParse(transactionElement.getAttribute("amount") ?? "0.0"),
    );
  }
}
