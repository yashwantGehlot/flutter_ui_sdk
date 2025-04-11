import 'package:xml/xml.dart';

class InsuranceMoneyBack {
  DateTime? date;
  String? description;
  double? amount;


  InsuranceMoneyBack({
    this.date,
    this.description,
    this.amount,
  });

  factory InsuranceMoneyBack.fromXmlElement(
    final XmlElement transactionElement,
  ) {
    final dateString = transactionElement.getAttribute("date");
    return InsuranceMoneyBack(
      description: transactionElement.getAttribute("description"),
      date: dateString != null
          ? DateTime.parse(dateString)
          : null,
      amount: double.tryParse(transactionElement.getAttribute("amount") ?? "0.0"),
    );
  }
}
