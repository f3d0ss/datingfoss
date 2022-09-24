import 'dart:io';

import 'package:datingfoss/chat/bloc/chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ListChatItem extends StatelessWidget {
  const ListChatItem({
    required this.name,
    required this.username,
    required this.messageText,
    required this.image,
    required this.time,
    required this.isMessageRead,
    super.key,
  });
  final String name;
  final String username;
  final String? messageText;
  final File? image;
  final DateTime? time;
  final bool isMessageRead;

  static const AssetImage noImageBackground =
      AssetImage('assets/images/noImageBackground.png');
  @override
  Widget build(BuildContext context) {
    late ImageProvider backgroundImage;
    if (image != null) {
      backgroundImage = FileImage(image!);
    } else {
      backgroundImage = noImageBackground;
    }
    return GestureDetector(
      onTap: () {
        context.read<ChatBloc>().add(ChatSelected(username: username));
      },
      child: Container(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: backgroundImage,
                    maxRadius: 30,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: ColoredBox(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            name,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            messageText ?? 'Say hi',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                              fontWeight: isMessageRead
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (time != null)
              Text(
                DateFormat('dd MMM kk:mm').format(time!),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight:
                      isMessageRead ? FontWeight.normal : FontWeight.bold,
                ),
              )
            else
              Container(),
          ],
        ),
      ),
    );
  }
}
