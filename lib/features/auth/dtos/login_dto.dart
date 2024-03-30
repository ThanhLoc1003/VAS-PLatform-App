class LoginDto {
  final String username;
  final String password;

  LoginDto({required this.username, required this.password});
  factory LoginDto.fromJson(Map<String, dynamic> json) {
    return LoginDto(
      username: json['username'],
      password: json['password'],
    );
  }
  Map<String, dynamic> toJson() => {"username": username, "password": password};
}
