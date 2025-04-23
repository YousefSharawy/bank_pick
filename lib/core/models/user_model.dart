class UserModel {
  String id;
  String name;
  String phone;
  String email;
  String profileImage;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.profileImage,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : this(id: json['id'], name: json['name'], email: json['email'],phone:json['phone'] ,profileImage:json['profileImage'] );

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'email': email};

}
