import 'package:datingfoss/chat/bloc/chat_bloc.dart';
import 'package:datingfoss/chat/bloc/chat_state.dart';
import 'package:datingfoss/chat/view/list_chat_item.dart';
import 'package:datingfoss/chat/view/single_chat_screen.dart';
import 'package:datingfoss/match/bloc/match_bloc.dart';
import 'package:datingfoss/partner_detail/view/partner_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';

class ListChatScreen extends StatelessWidget {
  const ListChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatState>(
      listenWhen: (previous, current) =>
          current.selectedChat.isNotEmpty &&
          (previous.selectedChat != current.selectedChat ||
              current.partnerDetailScreen == true),
      listener: (context, state) async {
        if (MediaQuery.of(context).orientation == Orientation.portrait) {
          final matchBlocState = context.read<MatchBloc>().state;
          final chatBloc = context.read<ChatBloc>();
          if (state.partnerDetailScreen == true) {
            await Navigator.of(context).push<dynamic>(
              PartnerDetailScreen.route(
                partnerUsername: state.selectedChat,
                keys: matchBlocState.partnerThatLikeMe[state.selectedChat],
              ),
            );
            chatBloc.add(const PartnerDetailExited());
          } else {
            await Navigator.push<Route<void>>(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return SingleChatScreen(
                    key: const Key('SingleChatScreen'),
                    partnerUsername: state.selectedChat,
                    keys: matchBlocState.partnerThatLikeMe[state.selectedChat],
                    bloc: chatBloc,
                  );
                },
              ),
            );
            chatBloc.add(const ChatSelected(username: ''));
          }
        }
      },
      child: Row(
        children: [
          Expanded(
            child: Scaffold(
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SafeArea(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 16, right: 16, top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const <Widget>[
                            Expanded(
                              child: Text(
                                'Conversations',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SearchBar(),
                    BlocBuilder<ChatBloc, ChatState>(
                      builder: (context, state) {
                        return ListView.builder(
                          reverse: true,
                          itemCount: state.chats.length,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 16),
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final key = state.chats.keys.elementAt(index);
                            final chat = state.chats[key]!;
                            Message? lastMessage;
                            if (chat.messages.isNotEmpty) {
                              lastMessage = chat.messages.first;
                            }
                            return ListChatItem(
                              name: chat.partner.name ?? chat.partner.username,
                              username: chat.partner.username,
                              messageText: lastMessage?.content,
                              image: chat.pic,
                              time: lastMessage?.timestamp,
                              isMessageRead: lastMessage?.isRead ?? false,
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (MediaQuery.of(context).orientation == Orientation.landscape)
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state.selectedChat.isNotEmpty) {
                    final matchBlocState = context.read<MatchBloc>().state;
                    return state.partnerDetailScreen
                        ? PartnerDetailScreen(
                            partnerUsername: state.selectedChat,
                            keys: matchBlocState
                                .partnerThatLikeMe[state.selectedChat],
                          )
                        : SingleChatScreen(
                            partnerUsername: state.selectedChat,
                            bloc: context.read<ChatBloc>(),
                          );
                  } else {
                    return Container();
                  }
                },
              ),
            )
        ],
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search...',
          hintStyle: TextStyle(color: Colors.grey.shade600),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey.shade600,
            size: 20,
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: const EdgeInsets.all(8),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.grey.shade100),
          ),
        ),
      ),
    );
  }
}
