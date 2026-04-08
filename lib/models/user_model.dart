class AppUser {
  final String id;
  final String fullName;
  final String email;

  const AppUser({
    required this.id,
    required this.fullName,
    required this.email,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'fullName': fullName,
        'email': email,
      };

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] as String,
      fullName: map['fullName'] as String,
      email: map['email'] as String,
    );
  }

  AppUser copyWith({
    String? id,
    String? fullName,
    String? email,
  }) {
    return AppUser(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
    );
  }
}
