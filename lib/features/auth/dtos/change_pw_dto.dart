class ChangePwDto {
  final String userId;
  final String oldPassword;
  final String newPassword;

  ChangePwDto(
      {required this.userId,
      required this.oldPassword,
      required this.newPassword});
  factory ChangePwDto.fromJson(Map<String, dynamic> json) {
    return ChangePwDto(
      userId: json['userId'] ?? '',
      oldPassword: json['oldPassword'] ?? '',
      newPassword: json['newPassword'] ?? '',
    );
  }
  Map<String, dynamic> toJson() => {
        "userId": userId,
        "oldPassword": oldPassword,
        "newPassword": newPassword,
      };
}
