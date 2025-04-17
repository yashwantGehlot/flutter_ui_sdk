// FI Types list from Rebit v2.1.0
enum FiType {
  deposit("DEPOSIT"),
  termDeposit("TERM_DEPOSIT"),
  termDeposit2("TERM-DEPOSIT"),
  recurringDeposit("RECURRING_DEPOSIT"),
  insurancePolicies("INSURANCE_POLICIES"),
  lifeInsurance("LIFE_INSURANCE"),
  generalInsurance("GENERAL_INSURANCE"),
  mutualFunds("MUTUAL_FUNDS"),
  equities("EQUITIES"),
  gstr13b("GSTR1_3B"),
  nps("NPS"),
  sip("SIP"),
  cp("CP"),
  govtSecurities("GOVT_SECURITIES"),
  bonds("BONDS"),
  debentures("DEBENTURES"),
  etf("ETF"),
  idr("IDR"),
  cis("CIS"),
  aif("AIF"),
  invit("INVIT"),
  reit("REIT"),
  other("OTHER");

  final String value;

  const FiType(this.value);
}

FiType? fiTypeFromString(String fiTypeString) {
  for (FiType type in FiType.values) {
    if (type.value == fiTypeString) {
      return type;
    }
  }
  return null;
}
