import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

class ChatState extends Equatable {
  const ChatState({
    required this.chats,
    required this.messageText,
    this.selectedChat = '',
    this.partnerDetailScreen = false,
  });

  factory ChatState.fromJson(Map<String, dynamic> json) =>
      _$ChatStateFromJson(json);

  Map<String, dynamic> toJson() => _$ChatStateToJson(this);

  final LinkedHashMap<String, Chat> chats;
  final String selectedChat;
  final bool partnerDetailScreen;
  final String messageText;

  @override
  List<Object> get props =>
      [chats, selectedChat, partnerDetailScreen, messageText];

  ChatState copyWith({
    LinkedHashMap<String, Chat>? chats,
    String? selectedChat,
    bool? partnerDetailScreen,
    String? messageText,
  }) {
    return ChatState(
      chats: chats ?? this.chats,
      selectedChat: selectedChat ?? this.selectedChat,
      partnerDetailScreen: partnerDetailScreen ?? this.partnerDetailScreen,
      messageText: messageText ?? this.messageText,
    );
  }

  bool get hasMessageUnread => chats.values
      .any((chat) => chat.messages.isNotEmpty && !chat.messages.first.isRead);
}

ChatState _$ChatStateFromJson(Map<String, dynamic> json) => ChatState(
      chats: LinkedHashMap.from(
        (json['chats'] as Map<String, dynamic>).map<String, Chat>(
          (k, dynamic e) =>
              MapEntry(k, Chat.fromJson(e as Map<String, dynamic>)),
        ),
      ),
      messageText: json['messageText'] as String,
    );

Map<String, dynamic> _$ChatStateToJson(ChatState instance) => <String, dynamic>{
      'chats': instance.chats,
      'messageText': instance.messageText,
    };
