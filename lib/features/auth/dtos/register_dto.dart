class RegisterDto {
  final String email;
  final String password;
  final String username;

  RegisterDto(
      {required this.email, required this.password, required this.username});
  Map<String, dynamic> toJson() {
    return {'username': username, 'email': email, 'password': password};
  }
}
