import 'package:xml/xml.dart';

class MutualFundHolder {
  String? name;
  DateTime? dob;
  String? mobile;
  String? nominee;
  String? dematId;
  String? folioNo;
  String? landline;
  String? address;
  String? email;
  String? pan;
  String? kycCompliance;

  MutualFundHolder({
    required this.name,
    required this.dob,
    required this.mobile,
    required this.nominee,
    required this.dematId,
    required this.folioNo,
    required this.landline,
    required this.address,
    required this.email,
    required this.pan,
    required this.kycCompliance,
  });

  factory MutualFundHolder.fromXmlElement(final XmlElement holderElement) {
    final dobDateString = holderElement.getAttribute("dob");

    return MutualFundHolder(
      name: holderElement.getAttribute("name"),
      dob: dobDateString != null
          ? DateTime.parse(dobDateString)
          : null,
      mobile: holderElement.getAttribute("mobile"),
      nominee: holderElement.getAttribute("nominee"),
      dematId: holderElement.getAttribute("dematId"),
      folioNo: holderElement.getAttribute("folioNo"),
      landline: holderElement.getAttribute("landline"),
      address: holderElement.getAttribute("address"),
      email: holderElement.getAttribute("email"),
      pan: holderElement.getAttribute("pan"),
      kycCompliance: holderElement.getAttribute("kycCompliance"),
    );
  }
}
