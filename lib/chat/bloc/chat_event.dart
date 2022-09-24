part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class MessageReceived extends ChatEvent {
  const MessageReceived({required this.message});
  final Message message;
}

class SendMessageRequested extends ChatEvent {
  const SendMessageRequested({required this.to});
  final String to;
}

class TextMessageEdited extends ChatEvent {
  const TextMessageEdited({required this.messageText});
  final String messageText;

  @override
  List<Object> get props => [messageText];
}

class NewMatchFound extends ChatEvent {
  const NewMatchFound({required this.username, required this.keys});
  final String username;
  final List<String> keys;
}

class MatchRemoved extends ChatEvent {
  const MatchRemoved({required this.username});
  final String username;
}

class MessageRead extends ChatEvent {
  const MessageRead({required this.username});
  final String username;
}

class ChatSelected extends ChatEvent {
  const ChatSelected({required this.username});

  final String username;
  @override
  List<Object> get props => [username];
}

class PartnerDetailSelected extends ChatEvent {
  const PartnerDetailSelected();
}

class PartnerDetailExited extends ChatEvent {
  const PartnerDetailExited();
}
