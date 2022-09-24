class NotificationDTO {
  NotificationDTO({required this.type, required this.content});
  factory NotificationDTO.fromJson(Map<String, dynamic> json) =>
      NotificationDTO(
        type: json['type'] as int,
        content: json['content'],
      );
  final int type;
  final dynamic content;
}
