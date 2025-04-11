import 'package:xml/xml.dart';

class Holder {
  String? name;
  String? mobile;
  String? landline;
  String? address;
  DateTime? dob;
  String? email;
  bool? kycCompliance;
  String? pan;
  String? nominee;
  String? dematId;

  Holder({
    this.name,
    this.mobile,
    this.landline,
    this.address,
    this.dob,
    this.email,
    this.kycCompliance,
    this.pan,
    this.nominee,
    this.dematId,
  });

  factory Holder.fromXmlElement(final XmlElement holderElement) {
    final dob = holderElement.getAttribute('dob');
    String? kycCompliance = holderElement.getAttribute('kycCompliance');
    kycCompliance ??= holderElement.getAttribute('ckycCompliance');
    return Holder(
      name: holderElement.getAttribute('name'),
      mobile: holderElement.getAttribute('mobile'),
      landline: holderElement.getAttribute('landline'),
      address: holderElement.getAttribute('address'),
      dob: dob != null ? DateTime.parse(dob) : null,
      email: holderElement.getAttribute('email'),
      kycCompliance: kycCompliance == "true",
      pan: holderElement.getAttribute('PAN'),
      nominee: holderElement.getAttribute('nominee'),
      dematId: holderElement.getAttribute('dematId'),
    );
  }
}
