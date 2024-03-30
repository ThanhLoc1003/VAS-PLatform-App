class NotificationDto {
  final String message;
  final bool isRead;
  final String id;
  final String recipient;
  final String sender;
  NotificationDto(
      {required this.id,
      required this.message,
      required this.isRead,
      required this.recipient,
      required this.sender});
  factory NotificationDto.fromJson(Map<String, dynamic> json) {
    return NotificationDto(
      id: json['_id'].toString(),
      message: json['message'],
      isRead: json['isRead'],
      recipient: json['recipient'],
      sender: json['sender'],
    );
  }
}
