class PickerModel {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? password;
  String? address;
  String? avatar;
  num? avgRating;
  String? status;
  bool? isActive;
  String? createdAt;
  String? updatedAt;

  PickerModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.password,
    this.address,
    this.avatar,
    this.avgRating,
    this.status,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  PickerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    password = json['password'];
    address = json['address'];
    avatar = json['avatar'];
    avgRating = json['avgRating'];
    status = json['status'];
    isActive = json['isActive'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['password'] = this.password;
    data['address'] = this.address;
    data['avatar'] = this.avatar;
    data['avgRating'] = this.avgRating;
    data['status'] = this.status;
    data['isActive'] = this.isActive;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
