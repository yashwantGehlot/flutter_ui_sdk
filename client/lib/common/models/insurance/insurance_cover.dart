import 'package:xml/xml.dart';

class InsuranceCover {
  String? description;
  double? amount;


  InsuranceCover({
    this.description,
    this.amount,
  });

  factory InsuranceCover.fromXmlElement(
    final XmlElement transactionElement,
  ) {
    return InsuranceCover(
      description: transactionElement.getAttribute("description"),
      amount: double.tryParse(transactionElement.getAttribute("amount") ?? "0.0"),
    );
  }
}
