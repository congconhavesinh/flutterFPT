class User {
  final String id;
  final String fullName;
  final String phone;
  final String? email;
  final String? dob;
  final String? gender;
  final String? address;
  final String className;
  final List<String> roles; // Chứa danh sách các quyền: ["ROLE_STUDENT", ...]
  final List<User>? children; // Dành cho trường hợp là Phụ huynh

  User({
    required this.id,
    required this.fullName,
    required this.phone,
    this.email,
    this.dob,
    this.gender,
    this.address,
    required this.className,
    required this.roles,
    this.children,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // Xử lý danh sách Roles từ API
    List<String> rolesList = [];
    if (json['roles'] != null) {
      rolesList = List<String>.from(json['roles']);
    }

    // Xử lý danh sách con (nếu có - dành cho Phụ huynh)
    List<User>? childrenList;
    if (json['children'] != null) {
      childrenList = (json['children'] as List)
          .map((childJson) => User.fromJson(childJson))
          .toList();
    }

    return User(
      // Chuyển đổi ID về int nếu API trả về chuỗi, hoặc giữ nguyên nếu là int
      id: json['id'] ,
      fullName: json['fullName'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'],
      dob: json['dob'],
      gender: json['gender'],
      address: json['address'],
      className: json['className'] ?? 'Chưa xếp lớp',
      roles: rolesList,
      children: childrenList,
    );
  }

  // Hàm tiện ích để kiểm tra quyền nhanh ở phía Flutter
  bool hasRole(String roleName) => roles.contains(roleName);
}