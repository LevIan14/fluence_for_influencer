class Negotiation {
  final String negotiationId;
  final String influencerId;
  final String umkmId;
  final String projectTitle;
  final String? projectDesc;
  final double projectPrice;
  final Map<String, DateTime> projectDuration;
  final String negotiationStatus;

  Negotiation(
    this.negotiationId,
    this.influencerId,
    this.umkmId,
    this.projectTitle,
    this.projectDesc,
    this.projectPrice,
    this.projectDuration,
    this.negotiationStatus,
  );
}
