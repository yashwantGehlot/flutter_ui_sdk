import 'package:xml/xml.dart';

class Pending {
  String? transactionType;
  double? amount;

  Pending({
    this.transactionType,
    this.amount,
  });

  factory Pending.fromXmlElement(final XmlElement pendingElement) {
    return Pending(
      transactionType: pendingElement.getAttribute("transactionType"),
      amount: double.tryParse(pendingElement.getAttribute("amount") ?? ""),
    );
  }
}
