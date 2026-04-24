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

  BorrowerData copyWith({
    String? fullName,
    String? cnic,
    String? city,
    String? employmentType,
    int? annualIncome,
    int? monthlyObligations,
    String? homeOwnership,
    int? employmentLength,
    int? creditScore,
    int? loanAmount,
    String? loanPurpose,
    int? loanTerm,
  }) {
    return BorrowerData(
      fullName: fullName ?? this.fullName,
      cnic: cnic ?? this.cnic,
      city: city ?? this.city,
      employmentType: employmentType ?? this.employmentType,
      annualIncome: annualIncome ?? this.annualIncome,
      monthlyObligations: monthlyObligations ?? this.monthlyObligations,
      homeOwnership: homeOwnership ?? this.homeOwnership,
      employmentLength: employmentLength ?? this.employmentLength,
      creditScore: creditScore ?? this.creditScore,
      loanAmount: loanAmount ?? this.loanAmount,
      loanPurpose: loanPurpose ?? this.loanPurpose,
      loanTerm: loanTerm ?? this.loanTerm,
    );
  }
}
