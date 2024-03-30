class HistoryDto {
  final DateTime timestamp;
  final String details;

  HistoryDto({required this.timestamp, required this.details});

  factory HistoryDto.fromJson(Map<String, dynamic> json) {
    return HistoryDto(
      timestamp: DateTime.parse(json['timestamp']).toLocal(),
      details: json['details'],
    );
  }
}
