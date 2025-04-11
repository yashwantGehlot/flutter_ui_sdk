import 'package:finvu_flutter_sdk/common/models/fi_models/deposit/pending.dart';
import 'package:xml/xml.dart';

class DepositSummary {
  String? type;
  String? branch;
  String? facility;
  String? ifscCode;
  String? micrCode;
  String? openingDate;
  String? currentODLimit;
  String? drawingLimit;
  Pending? pending;
  String? currentBalance;
  String? currency;
  DateTime? balanceDateTime;
  String? status;

  DepositSummary({
    this.type,
    this.branch,
    this.facility,
    this.ifscCode,
    this.micrCode,
    this.openingDate,
    this.currentODLimit,
    this.drawingLimit,
    this.pending,
    this.currentBalance,
    this.currency,
    this.balanceDateTime,
    this.status,
  });

  factory DepositSummary.fromXmlElement(final XmlElement summaryElement) {
    final balanceDateTime = summaryElement.getAttribute("balanceDateTime");
    final pendingElement = summaryElement.findElements("Pending");

    final pending = pendingElement.isNotEmpty
        ? Pending.fromXmlElement(pendingElement.first)
        : null;

    return DepositSummary(
      type: summaryElement.getAttribute("type"),
      branch: summaryElement.getAttribute("branch"),
      facility: summaryElement.getAttribute("facility"),
      ifscCode: summaryElement.getAttribute("ifscCode"),
      micrCode: summaryElement.getAttribute("micrCode"),
      openingDate: summaryElement.getAttribute("openingDate"),
      currentODLimit: summaryElement.getAttribute("currentODLimit"),
      drawingLimit: summaryElement.getAttribute("drawingLimit"),
      pending: pending,
      currentBalance: summaryElement.getAttribute("currentBalance"),
      currency: summaryElement.getAttribute("currency"),
      balanceDateTime:
          balanceDateTime != null ? DateTime.parse(balanceDateTime) : null,
      status: summaryElement.getAttribute("status"),
    );
  }
}
