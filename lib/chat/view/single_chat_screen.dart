import 'package:datingfoss/chat/bloc/chat_bloc.dart';
import 'package:datingfoss/chat/bloc/chat_state.dart';
import 'package:datingfoss/chat/view/single_chat_item.dart';
import 'package:datingfoss/partner_detail/view/partner_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SingleChatScreen extends StatefulWidget {
  const SingleChatScreen({
    required String partnerUsername,
    List<String>? keys,
    required ChatBloc bloc,
    super.key,
  })  : _partnerUsername = partnerUsername,
        _keys = keys,
        _bloc = bloc;

  final String _partnerUsername;
  final List<String>? _keys;
  final ChatBloc _bloc;
  static const AssetImage noImageBackground =
      AssetImage('assets/images/noImageBackground.png');

  @override
  State<SingleChatScreen> createState() => _SingleChatScreenState();
}

class _SingleChatScreenState extends State<SingleChatScreen> {
  final textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatBloc>.value(
      value: widget._bloc,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        appBar: _appBar(context),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                child: BlocBuilder<ChatBloc, ChatState>(
                  bloc: widget._bloc,
                  buildWhen: (previous, current) =>
                      previous.chats[widget._partnerUsername]!.messages !=
                      current.chats[widget._partnerUsername]!.messages,
                  builder: (context, state) {
                    final chat = state.chats[widget._partnerUsername]!;
                    if (chat.messages.isNotEmpty &&
                        chat.messages.first.from.isNotEmpty) {
                      widget._bloc
                          .add(MessageRead(username: widget._partnerUsername));
                    }
                    return ListView.builder(
                      reverse: true,
                      itemCount: chat.messages.length,
                      itemBuilder: (context, index) {
                        final message = chat.messages.elementAt(index);
                        final received =
                            message.from == widget._partnerUsername;
                        return ChatItemWidget(
                          content: message.content,
                          received: received,
                          timestamp: message.timestamp,
                          key: Key(
                            message.content +
                                (message.timestamp?.toIso8601String() ?? ''),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: textController,
                      onChanged: (text) => widget._bloc
                          .add(TextMessageEdited(messageText: text)),
                      decoration: const InputDecoration(hintText: 'Message'),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      textController.clear();
                      widget._bloc.add(
                        SendMessageRequested(to: widget._partnerUsername),
                      );
                    },
                    child: const Text('Send'),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      flexibleSpace: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(right: 16),
          child: BlocBuilder<ChatBloc, ChatState>(
            bloc: widget._bloc,
            builder: (context, state) {
              final chat = state.chats[widget._partnerUsername]!;
              final partner = chat.partner;
              late ImageProvider backgroundImage;
              if (chat.pic != null) {
                backgroundImage = FileImage(chat.pic!);
              } else {
                backgroundImage = SingleChatScreen.noImageBackground;
              }
              return Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      widget._bloc.add(const ChatSelected(username: ''));
                      if (MediaQuery.of(context).orientation ==
                          Orientation.portrait) {
                        Navigator.of(context).pop();
                      }
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 2),
                  CircleAvatar(backgroundImage: backgroundImage, maxRadius: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          // ignore: lines_longer_than_80_chars
                          '${partner.name ?? partner.username} ${partner.surname ?? ''}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          partner.username,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      if (MediaQuery.of(context).orientation ==
                          Orientation.portrait) {
                        await Navigator.of(context).push<dynamic>(
                          PartnerDetailScreen.route(
                            partnerUsername: widget._partnerUsername,
                            keys: widget._keys,
                          ),
                        );
                      } else {
                        widget._bloc.add(const PartnerDetailSelected());
                      }
                    },
                    icon: const Icon(Icons.remove_red_eye_outlined),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
