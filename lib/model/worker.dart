class Worker {
  String? workerId;
  String? fullName;
  String? email;
  String? phone;
  String? address;
  String? username;

  Worker({
    this.workerId,
    this.fullName,
    this.email,
    this.phone,
    this.address,
    this.username,
  });

  Worker.fromJson(Map<String, dynamic> json) {
    workerId = json['id']?.toString();
    fullName = json['full_name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    username = json['username'];
  }

  String? get id => workerId;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = workerId;
    data['full_name'] = fullName;
    data['email'] = email;
    data['phone'] = phone;
    data['address'] = address;
    data['username'] = username;
    return data;
  }

  static String hashPassword(String password) {
    return password;
  }
}
