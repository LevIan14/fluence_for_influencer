class Agreement {
  final String agreementId;
  final String influencerId;
  final String umkmId;
  final String negotiationId;
  final String? umkmAgreement;
  final String umkmAgreementStatus;
  final String? influencerAgreement;
  final String influencerAgreementStatus;
  final DateTime createdAt;

  Agreement(
      this.agreementId,
      this.influencerId,
      this.umkmId,
      this.negotiationId,
      this.umkmAgreement,
      this.umkmAgreementStatus,
      this.influencerAgreement,
      this.influencerAgreementStatus,
      this.createdAt);
}
