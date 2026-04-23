class BorrowerData {
  String fullName;
  String cnic;
  String city;
  String employmentType;
  int annualIncome;
  int monthlyObligations;
  String homeOwnership;
  int employmentLength;
  int creditScore;
  int loanAmount;
  String loanPurpose;
  int loanTerm;

  BorrowerData({
    required this.fullName,
    required this.cnic,
    required this.city,
    required this.employmentType,
    required this.annualIncome,
    required this.monthlyObligations,
    required this.homeOwnership,
    required this.employmentLength,
    required this.creditScore,
    required this.loanAmount,
    required this.loanPurpose,
    required this.loanTerm,
  });

  copyWith({
    required String fullName,
    required String cnic,
    required String city,
    required String employmentType,
    required int annualIncome,
    required int monthlyObligations,
    required int employmentLength,
    required int creditScore,
    required int loanAmount,
    required String loanPurpose,
    required int loanTerm,
  }) {}
}
