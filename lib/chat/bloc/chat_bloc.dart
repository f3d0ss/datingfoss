import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:datingfoss/chat/bloc/chat_state.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';

part 'chat_event.dart';

class ChatBloc extends HydratedBloc<ChatEvent, ChatState> {
  ChatBloc({
    required ChatRepository chatRepository,
    required DiscoverRepository discoverRepository,
  })  : _chatRepository = chatRepository,
        _discoverRepository = discoverRepository,
        super(
          ChatState(chats: LinkedHashMap<String, Chat>(), messageText: ''),
        ) {
    on<SendMessageRequested>(_onSendMessageRequested);
    on<TextMessageEdited>(_onTextMessageEdited);
    on<MessageRead>(_onMessageRead);
    on<MessageReceived>(_onMessageReceived);
    on<ChatSelected>(_onChatSelected);
    on<PartnerDetailSelected>(_onPartnerDetailSelected);
    on<PartnerDetailExited>(_onPartnerDetailExited);
    on<NewMatchFound>(_onNewMatchFound);
    on<MatchRemoved>(_onMatchRemoved);
    _messageSubscription = _chatRepository.messages
        .listen((message) => add(MessageReceived(message: message)));
  }

  @override
  Future<void> close() async {
    await _messageSubscription.cancel();
    await super.close();
  }

  final ChatRepository _chatRepository;
  final DiscoverRepository _discoverRepository;
  late StreamSubscription<Message> _messageSubscription;

  Future<void> _onSendMessageRequested(
    SendMessageRequested event,
    Emitter<ChatState> emit,
  ) async {
    final content = state.messageText;
    final pendingMessageToBeSent = Message(
      content: content,
      from: '',
      isRead: true,
    );
    final partnerUsername = event.to;
    final partner =
        await _discoverRepository.fetchPartner(username: partnerUsername);
    final pic = await _getPic(partner: partner);

    var newChats = LinkedHashMap<String, Chat>.from(state.chats)
      ..remove(partnerUsername)
      ..putIfAbsent(
        partnerUsername,
        () => Chat(
          pic: pic,
          partner: partner,
          messages:
              ListQueue<Message>.from(state.chats[partnerUsername]!.messages)
                ..addFirst(pendingMessageToBeSent),
        ),
      );
    final pendingState = state.copyWith(chats: newChats, messageText: '');
    emit(pendingState);
    final sendTime = await _chatRepository.sendMessage(
      to: partnerUsername,
      message: content,
    );
    final message = Message(
      content: content,
      from: '',
      timestamp: sendTime,
      isRead: true,
    );
    newChats = LinkedHashMap<String, Chat>.from(pendingState.chats)
      ..update(
        partnerUsername,
        (chat) => Chat(
          partner: chat.partner,
          pic: chat.pic,
          messages: ListQueue<Message>.from(chat.messages)
            ..remove(pendingMessageToBeSent)
            ..addFirst(message),
        ),
      );
    emit(
      pendingState.copyWith(chats: newChats),
    );
  }

  Future<void> _onTextMessageEdited(
    TextMessageEdited event,
    Emitter<ChatState> emit,
  ) async {
    final content = event.messageText;
    final newState = state.copyWith(messageText: content);
    emit(newState);
  }

  Future<void> _onMessageReceived(
    MessageReceived event,
    Emitter<ChatState> emit,
  ) async {
    final partnerUsername = event.message.from;
    if (!state.chats.containsKey(partnerUsername)) return;
    final partner =
        await _discoverRepository.fetchPartner(username: partnerUsername);
    final pic = await _getPic(partner: partner);
    final newChats = LinkedHashMap<String, Chat>.from(state.chats)
      ..remove(partnerUsername)
      ..putIfAbsent(
        partnerUsername,
        () => Chat(
          partner: partner,
          pic: pic,
          messages: ListQueue<Message>.from(
            state.chats[partnerUsername]?.messages ?? <Message>[],
          )..addFirst(event.message),
        ),
      );
    emit(state.copyWith(chats: newChats));
  }

  Future<void> _onMessageRead(
    MessageRead event,
    Emitter<ChatState> emit,
  ) async {
    final partnerUsername = event.username;
    final oldChat = state.chats[partnerUsername]!;
    if (oldChat.messages.isNotEmpty && oldChat.messages.first.from.isNotEmpty) {
      final lastMessage = oldChat.messages.first;
      final newMessage = Message(
        content: lastMessage.content,
        from: lastMessage.from,
        isRead: true,
        timestamp: lastMessage.timestamp,
      );
      final newChats = LinkedHashMap<String, Chat>.from(state.chats)
        ..remove(partnerUsername)
        ..putIfAbsent(
          partnerUsername,
          () => Chat(
            partner: oldChat.partner,
            pic: oldChat.pic,
            messages: ListQueue<Message>.from(oldChat.messages)
              ..removeFirst()
              ..addFirst(newMessage),
          ),
        );
      emit(state.copyWith(chats: newChats));
    }
  }

  Future<void> _onChatSelected(
    ChatSelected event,
    Emitter<ChatState> emit,
  ) async {
    final partnerUsername = event.username;
    final newState = state.copyWith(
      selectedChat: partnerUsername,
      partnerDetailScreen: false,
    );
    emit(newState);
  }

  Future<void> _onPartnerDetailSelected(
    PartnerDetailSelected event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(partnerDetailScreen: true));
  }

  Future<void> _onPartnerDetailExited(
    PartnerDetailExited event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(partnerDetailScreen: false));
  }

  Future<void> _onNewMatchFound(
    NewMatchFound event,
    Emitter<ChatState> emit,
  ) async {
    final partnerUsername = event.username;

    final partner =
        await _discoverRepository.fetchPartner(username: partnerUsername);
    final pic = await _getPic(partner: partner);
    final newChats = LinkedHashMap<String, Chat>.from(state.chats)
      ..putIfAbsent(
        partnerUsername,
        () => Chat(partner: partner, pic: pic, messages: ListQueue()),
      );
    emit(state.copyWith(chats: newChats));
  }

  Future<void> _onMatchRemoved(
    MatchRemoved event,
    Emitter<ChatState> emit,
  ) async {
    final partnerUsername = event.username;
    final newChats = LinkedHashMap<String, Chat>.from(state.chats)
      ..remove(partnerUsername);
    if (partnerUsername == state.selectedChat) {
      emit(
        state.copyWith(
          chats: newChats,
          selectedChat: '',
          partnerDetailScreen: false,
        ),
      );
    } else {
      emit(state.copyWith(chats: newChats));
    }
  }

  Future<File?> _getPic({required Partner partner}) async {
    final publicPictureIds = partner.publicInfo.pictures;
    for (final picId in publicPictureIds) {
      try {
        return await _discoverRepository.fetchPublicImage(
          username: partner.username,
          id: picId,
        );
      } catch (_) {
        // go on and fetch next
      }
    }
    return null;
  }

  @override
  ChatState fromJson(Map<String, dynamic> json) {
    return ChatState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(ChatState state) {
    return state.toJson();
  }
}
