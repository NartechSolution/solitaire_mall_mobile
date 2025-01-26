class RequestStatusModel {
  Request? request;
  PickerDetails? pickerDetails;

  RequestStatusModel({
    required this.request,
    required this.pickerDetails,
  });

  RequestStatusModel.fromJson(Map<String, dynamic> json) {
    request =
        json['request'] != null ? Request.fromJson(json['request']) : null;
    pickerDetails = json['pickerDetails'] != null
        ? PickerDetails.fromJson(json['pickerDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (request != null) {
      data['request'] = request!.toJson();
    }
    if (pickerDetails != null) {
      data['pickerDetails'] = pickerDetails!.toJson();
    }
    return data;
  }
}

class Request {
  String? id;
  String? customerId;
  String? pickerId;
  String? status;
  double? customerLat;
  double? customerLng;
  String? location;
  String? createdAt;
  String? updatedAt;

  Request({
    id,
    customerId,
    pickerId,
    status,
    customerLat,
    customerLng,
    location,
    createdAt,
    updatedAt,
  });

  Request.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customerId'];
    pickerId = json['pickerId'];
    status = json['status'];
    customerLat = json['customerLat'];
    customerLng = json['customerLng'];
    location = json['location'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['customerId'] = customerId;
    data['pickerId'] = pickerId;
    data['status'] = status;
    data['customerLat'] = customerLat;
    data['customerLng'] = customerLng;
    data['location'] = location;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class PickerDetails {
  String? id;
  String? name;
  String? phone;
  String? avatar;
  num? avgRating;

  PickerDetails({
    required this.id,
    required this.name,
    required this.phone,
    required this.avatar,
    required this.avgRating,
  });

  PickerDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    avatar = json['avatar'];
    avgRating = json['avgRating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['phone'] = phone;
    data['avatar'] = avatar;
    data['avgRating'] = avgRating;
    return data;
  }
}
