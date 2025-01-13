class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final bool? hasFingerprint;
  final bool? hasNfcCard;
  final String? address;
  final String? avatar;
  final String? token;
  final String? image;
  final String? password;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.hasFingerprint,
    this.hasNfcCard,
    this.address,
    this.avatar,
    this.token,
    this.image,
    this.password,
  });

  // Factory constructor to create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      hasFingerprint: json['hasFingerprint'] as bool,
      hasNfcCard: json['hasNfcCard'] as bool,
      address: json['address'] as String?,
      avatar: json['avatar'] as String?,
      token: json['token'] as String,
      image: json['image'],
      password: json['password'] as String?,
    );
  }

  // Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'hasFingerprint': hasFingerprint,
      'hasNfcCard': hasNfcCard,
      'address': address,
      'avatar': avatar,
      'token': token,
      'image': image,
    };
  }

  // Create a copy of UserModel with some fields updated
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    bool? hasFingerprint,
    bool? hasNfcCard,
    String? address,
    String? avatar,
    String? token,
    String? image,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      hasFingerprint: hasFingerprint ?? this.hasFingerprint,
      hasNfcCard: hasNfcCard ?? this.hasNfcCard,
      address: address ?? this.address,
      avatar: avatar ?? this.avatar,
      token: token ?? this.token,
      image: image ?? this.image,
    );
  }
}
