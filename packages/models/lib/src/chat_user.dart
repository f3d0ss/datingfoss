import 'dart:collection';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

class Chat extends Equatable {
  const Chat({
    required this.partner,
    required this.messages,
    this.pic,
  });
  factory Chat.fromJson(Map<String, dynamic> json) => _chatFromJson(json);

  Map<String, dynamic> toJson() => _chatToJson(this);
  final Partner partner;
  final ListQueue<Message> messages;
  final File? pic;

  @override
  List<Object?> get props => [partner, messages];

  Map<String, dynamic> _chatToJson(Chat instance) => <String, dynamic>{
        'partner': instance.partner,
        'messages': instance.messages.toList(),
        'pic': instance.pic?.path,
      };
}

Chat _chatFromJson(Map<String, dynamic> json) => Chat(
      pic: json['pic'] == null ? null : File(json['pic'] as String),
      partner: Partner.fromJson(json['partner'] as Map<String, dynamic>),
      messages: ListQueue<Message>.from(
        (json['messages'] as List<dynamic>)
            .map((dynamic e) => Message.fromJson(e as Map<String, dynamic>))
            .toList(),
      ),
    );
