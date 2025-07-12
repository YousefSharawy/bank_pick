class UserModel {
  String id;
  String name;
  String phone;
  String email;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : this(id: json['id'], name: json['name'], email: json['email'],phone:json['phone'] );

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'email': email};

}
