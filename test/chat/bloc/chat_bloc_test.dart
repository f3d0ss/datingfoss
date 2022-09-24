import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:datingfoss/chat/bloc/chat_bloc.dart';
import 'package:datingfoss/chat/bloc/chat_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';

import '../../helpers/hydrated_bloc.dart';

class MockDiscoverRepository extends Mock implements DiscoverRepository {}

class MockChatRepository extends Mock implements ChatRepository {}

class MockPartner extends Mock implements Partner {}

void main() {
  group('ChatBloc', () {
    late DiscoverRepository discoverRepository;
    late ChatRepository chatRepository;
    late Partner partner;
    late String partnerUsername;
    late List<String> partnerKeys;
    late File pic;

    setUp(() {
      discoverRepository = MockDiscoverRepository();
      chatRepository = MockChatRepository();
      partnerUsername = 'pippo';
      partner = Partner(
        username: partnerUsername,
        publicInfo: PublicInfo(
          pictures: const ['picId1'],
          interests: const ['interest1'],
          textInfo: const {'name': 'bob'},
          boolInfo: const {'boolInfo': true},
          dateInfo: {'dateInfo': DateTime(1990)},
          sex: 0.1,
          searching: const RangeValues(0.1, 0.9),
        ),
        privateInfo: const PrivateInfo(
          pictures: [PrivatePic(picId: 'privPicId', keyIndex: 0)],
          interests: ['privInterest'],
        ),
        jsonPublicKey: const {},
      );
      partnerKeys = ['key1'];
      pic = File('test_resources/pic1.jpg');
      when(() => chatRepository.messages).thenAnswer(
        (_) => const Stream.empty(),
      );
      when(
        () => discoverRepository.fetchPartner(username: partnerUsername),
      ).thenAnswer((_) async => partner);
      when(
        () => discoverRepository.fetchPublicImage(
          username: any(named: 'username'),
          id: any(named: 'id'),
        ),
      ).thenAnswer(
        (_) async => pic,
      );
      when(
        () => discoverRepository.fetchPrivateImage(
          username: any(named: 'username'),
          id: any(named: 'id'),
          base64Key: any(named: 'base64Key'),
        ),
      ).thenAnswer(
        (_) async => pic,
      );
    });

    test('initial state is an empty ChatState', () async {
      mockHydratedStorage();
      expect(
        ChatBloc(
          chatRepository: chatRepository,
          discoverRepository: discoverRepository,
        ).state,
        ChatState(messageText: '', chats: LinkedHashMap<String, Chat>()),
      );
    });

    test('can got to json and back', () async {
      mockHydratedStorage();
      final chatState = ChatState(chats: LinkedHashMap(), messageText: '');
      final chatBloc = ChatBloc(
        chatRepository: chatRepository,
        discoverRepository: discoverRepository,
      );
      expect(
        chatBloc.fromJson(chatBloc.toJson(chatState)!),
        chatState,
      );
    });

    test('can close', () async {
      mockHydratedStorage();
      await ChatBloc(
        chatRepository: chatRepository,
        discoverRepository: discoverRepository,
      ).close();
    });

    group('NewMatchFound', () {
      test('add the new chat to the state', () async {
        mockHydratedStorage();
        final bloc = ChatBloc(
          discoverRepository: discoverRepository,
          chatRepository: chatRepository,
        )..add(NewMatchFound(username: partnerUsername, keys: partnerKeys));
        await expectLater(
          bloc.stream,
          emits(
            ChatState(
              messageText: '',
              chats: LinkedHashMap<String, Chat>.from({
                partnerUsername: Chat(
                  partner: partner,
                  pic: pic,
                  messages: ListQueue(),
                )
              }),
            ),
          ),
        );
      });
    });

    group('with a chat already created', () {
      late ChatBloc bloc;
      setUp(() async {
        mockHydratedStorage();
        bloc = ChatBloc(
          discoverRepository: discoverRepository,
          chatRepository: chatRepository,
        )..emit(
            ChatState(
              messageText: '',
              chats: LinkedHashMap<String, Chat>.from({
                partnerUsername: Chat(
                  partner: partner,
                  pic: pic,
                  messages: ListQueue(),
                )
              }),
            ),
          );
      });

      group('MatchRemoved', () {
        test('remove the chat', () async {
          bloc.add(MatchRemoved(username: partnerUsername));
          await expectLater(
            bloc.stream,
            emits(
              ChatState(
                messageText: '',
                chats: LinkedHashMap<String, Chat>.from({}),
              ),
            ),
          );
        });
      });

      group('SendMessageRequested', () {
        const messageText = 'Hi bruh';
        final sendMessageTime = DateTime.now();
        setUp(() {
          when(
            () => chatRepository.sendMessage(
              to: partnerUsername,
              message: messageText,
            ),
          ).thenAnswer((_) async => sendMessageTime);
        });
        test('add sended message as pending and as sent', () async {
          bloc
            ..add(const TextMessageEdited(messageText: messageText))
            ..add(
              SendMessageRequested(to: partnerUsername),
            );
          await expectLater(
            bloc.stream,
            emitsInOrder(
              [
                ChatState(
                  messageText: messageText,
                  chats: LinkedHashMap<String, Chat>.from({
                    partnerUsername: Chat(
                      partner: partner,
                      pic: pic,
                      messages: ListQueue(),
                    )
                  }),
                ),
                ChatState(
                  messageText: '',
                  chats: LinkedHashMap<String, Chat>.from({
                    partnerUsername: Chat(
                      partner: partner,
                      pic: pic,
                      messages: ListQueue()
                        ..addFirst(
                          const Message(
                            content: messageText,
                            from: '',
                            isRead: true,
                          ),
                        ),
                    )
                  }),
                ),
                ChatState(
                  messageText: '',
                  chats: LinkedHashMap<String, Chat>.from({
                    partnerUsername: Chat(
                      partner: partner,
                      pic: pic,
                      messages: ListQueue()
                        ..addFirst(
                          Message(
                            content: messageText,
                            from: '',
                            isRead: true,
                            timestamp: sendMessageTime,
                          ),
                        ),
                    )
                  }),
                )
              ],
            ),
          );
        });
      });
      group('MessageReceived', () {
        const messageText = 'Hi bruh';
        final sendMessageTime = DateTime.now();
        late Message message;
        setUp(() {
          message = Message(
            content: messageText,
            from: partnerUsername,
            isRead: false,
          );
          when(
            () => chatRepository.sendMessage(
              to: partnerUsername,
              message: messageText,
            ),
          ).thenAnswer((_) async => sendMessageTime);
        });
        test('add sended message as pending and as sent', () async {
          bloc.add(MessageReceived(message: message));
          await expectLater(
            bloc.stream,
            emits(
              ChatState(
                messageText: '',
                chats: LinkedHashMap<String, Chat>.from({
                  partnerUsername: Chat(
                    partner: partner,
                    pic: pic,
                    messages: ListQueue()..addFirst(message),
                  )
                }),
              ),
            ),
          );
        });
      });

      group('MessageRead', () {
        const messageText = 'Hi bruh';
        final sendMessageTime = DateTime.now();
        late Message unreadMessage;
        late Message readMessage;
        setUp(() {
          unreadMessage = Message(
            content: messageText,
            from: partnerUsername,
            isRead: false,
          );
          readMessage = Message(
            content: messageText,
            from: partnerUsername,
            isRead: true,
          );
          when(
            () => chatRepository.sendMessage(
              to: partnerUsername,
              message: messageText,
            ),
          ).thenAnswer((_) async => sendMessageTime);
          bloc.emit(
            ChatState(
              messageText: '',
              chats: LinkedHashMap<String, Chat>.from({
                partnerUsername: Chat(
                  partner: partner,
                  pic: pic,
                  messages: ListQueue()..addFirst(unreadMessage),
                )
              }),
            ),
          );
        });
        test('add sended message as pending and as sent', () async {
          bloc.add(MessageRead(username: partnerUsername));
          await expectLater(
            bloc.stream,
            emits(
              ChatState(
                messageText: '',
                chats: LinkedHashMap<String, Chat>.from({
                  partnerUsername: Chat(
                    partner: partner,
                    pic: pic,
                    messages: ListQueue()..addFirst(readMessage),
                  )
                }),
              ),
            ),
          );
        });
      });

      group('ChatSelected', () {
        setUp(() {
          bloc.emit(
            ChatState(
              messageText: '',
              chats: LinkedHashMap<String, Chat>.from({
                partnerUsername: Chat(
                  partner: partner,
                  pic: pic,
                  messages: ListQueue(),
                )
              }),
            ),
          );
        });
        test('add sended message as pending and as sent', () async {
          bloc.add(ChatSelected(username: partnerUsername));
          await expectLater(
            bloc.stream,
            emits(
              ChatState(
                messageText: '',
                selectedChat: partnerUsername,
                chats: LinkedHashMap<String, Chat>.from({
                  partnerUsername: Chat(
                    partner: partner,
                    pic: pic,
                    messages: ListQueue(),
                  )
                }),
              ),
            ),
          );
        });
      });

      group('PartnerDetailSelected', () {
        setUp(() {
          bloc.emit(
            ChatState(
              messageText: '',
              selectedChat: partnerUsername,
              chats: LinkedHashMap<String, Chat>.from({
                partnerUsername: Chat(
                  partner: partner,
                  pic: pic,
                  messages: ListQueue(),
                )
              }),
            ),
          );
        });
        test('add sended message as pending and as sent', () async {
          bloc.add(const PartnerDetailSelected());
          await expectLater(
            bloc.stream,
            emits(
              ChatState(
                messageText: '',
                selectedChat: partnerUsername,
                partnerDetailScreen: true,
                chats: LinkedHashMap<String, Chat>.from({
                  partnerUsername: Chat(
                    partner: partner,
                    pic: pic,
                    messages: ListQueue(),
                  )
                }),
              ),
            ),
          );
        });
      });

      group('PartnerDetailExited', () {
        setUp(() {
          bloc.emit(
            ChatState(
              messageText: '',
              selectedChat: partnerUsername,
              partnerDetailScreen: true,
              chats: LinkedHashMap<String, Chat>.from({
                partnerUsername: Chat(
                  partner: partner,
                  pic: pic,
                  messages: ListQueue(),
                )
              }),
            ),
          );
        });
        test('add sended message as pending and as sent', () async {
          bloc.add(const PartnerDetailExited());
          await expectLater(
            bloc.stream,
            emits(
              ChatState(
                messageText: '',
                selectedChat: partnerUsername,
                chats: LinkedHashMap<String, Chat>.from({
                  partnerUsername: Chat(
                    partner: partner,
                    pic: pic,
                    messages: ListQueue(),
                  )
                }),
              ),
            ),
          );
        });
      });
    });
  });
}
