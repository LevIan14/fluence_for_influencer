class Negotiation {
  final String negotiationId;
  final String projectTitle;
  final String? projectDesc;
  final double amount;
  final String rangeDate;
  final String influencerId;
  final String umkmId;

  Negotiation(this.negotiationId, this.projectTitle, this.projectDesc,
      this.amount, this.rangeDate, this.influencerId, this.umkmId);
}
