class Umkm {
  final String userId;
  final String email;
  String? password;

  String avatarUrl;
  String fullname;
  String location;
  String about;
  String? noteAgreement;

  late List<dynamic> categoryType;

  Umkm(this.userId, this.email, this.password, this.avatarUrl, this.fullname,
      this.location, this.about, this.noteAgreement, this.categoryType);

  factory Umkm.fromJson(String userId, Map<String, dynamic> json) {
    return Umkm(
        userId,
        json['email'],
        json['password'],
        json['avatar_url'],
        json['fullname'],
        json['location'],
        json['about'],
        json['note_agreement'],
        json['category_type_id']);
  }
}
