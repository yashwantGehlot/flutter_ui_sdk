import 'package:xml/xml.dart';

class InsuranceHolder {
  String? rank;
  String? name;
  DateTime? dob;
  String? mobile;
  String? nominee;
  String? landline;
  String? address;
  String? email;
  String? pan;
  String? ckycCompliance;

  InsuranceHolder({
    required this.name,
    required this.dob,
    required this.mobile,
    required this.nominee,
    required this.landline,
    required this.address,
    required this.email,
    required this.pan,
    required this.ckycCompliance,
  });

  factory InsuranceHolder.fromXmlElement(final XmlElement holderElement) {
    final dobDateString = holderElement.getAttribute("dob");

    return InsuranceHolder(
      name: holderElement.getAttribute("name"),
      dob: dobDateString != null
          ? DateTime.parse(dobDateString)
          : null,
      mobile: holderElement.getAttribute("mobile"),
      nominee: holderElement.getAttribute("nominee"),
      landline: holderElement.getAttribute("landline"),
      address: holderElement.getAttribute("address"),
      email: holderElement.getAttribute("email"),
      pan: holderElement.getAttribute("pan"),
      ckycCompliance: holderElement.getAttribute("kycCompliance"),
    );
  }
}
