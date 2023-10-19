class NhanVien {
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? password;

  NhanVien({this.id, this.name, this.email, this.phone, this.password});

  // nếu dùng localhost thì phai them _id de doc dc id
  factory NhanVien.fromJson(Map<String, dynamic> json) {
    return NhanVien(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
    };
  }
}