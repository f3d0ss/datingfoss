import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatItemWidget extends StatelessWidget {
  const ChatItemWidget({
    super.key,
    required this.content,
    required this.received,
    required this.timestamp,
  });

  final String content;
  final bool received;
  final DateTime? timestamp;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        buildMessageContainer(isSelf: !received),
        buildTimeStamp(
          context: context,
          isSelf: !received,
          timeStamp: timestamp,
        ),
      ],
    );
  }

  Row buildMessageContainer({required bool isSelf}) {
    const lrEdgeInsets = 15.0;
    const tbEdgeInsets = 10.0;
    return Row(
      mainAxisAlignment: isSelf
          ? MainAxisAlignment.end
          : MainAxisAlignment.start, // aligns the chatitem to right end
      children: <Widget>[
        Container(
          padding: const EdgeInsets.fromLTRB(
            lrEdgeInsets,
            tbEdgeInsets,
            lrEdgeInsets,
            tbEdgeInsets,
          ),
          constraints: const BoxConstraints(maxWidth: 200),
          decoration: BoxDecoration(
            color: isSelf ? Colors.green : Colors.orange,
            borderRadius: BorderRadius.circular(8),
          ),
          margin: EdgeInsets.only(
            right: isSelf ? 10 : 0,
            left: isSelf ? 0 : 10,
          ),
          child: buildMessageContent(
            isSelf: isSelf,
            content: content,
          ),
        )
      ],
    );
  }

  Widget buildMessageContent({
    required bool isSelf,
    required String content,
  }) {
    return Text(
      content,
      style: TextStyle(color: isSelf ? Colors.black : Colors.white),
    );
  }

  Row buildTimeStamp({
    required BuildContext context,
    required bool isSelf,
    required DateTime? timeStamp,
  }) {
    return Row(
      mainAxisAlignment:
          isSelf ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
            left: isSelf ? 5 : 0,
            right: isSelf ? 0 : 5,
            top: 5,
            bottom: 5,
          ),
          child: timestamp != null
              ? Text(
                  DateFormat('dd MMM kk:mm').format(timeStamp!.toLocal()),
                  style: Theme.of(context).textTheme.caption,
                )
              : Container(),
        )
      ],
    );
  }
}
