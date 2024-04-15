import 'package:flutter/material.dart';
import '../../domain/message.dart';

class MessageWidget extends StatelessWidget {
  final Message message;
  final bool isMe; // Determine if the message was sent by the current user

  const MessageWidget({
    Key? key,
    required this.message,
    required this.isMe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bg = isMe ? Colors.blue : Colors.grey[200];
    final align = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final icon = isMe ? Icons.done_all : null;
    final radius = isMe
        ? BorderRadius.only(
      topLeft: Radius.circular(12),
      bottomLeft: Radius.circular(12),
      bottomRight: Radius.circular(12),
    )
        : BorderRadius.only(
      topRight: Radius.circular(12),
      bottomLeft: Radius.circular(12),
      bottomRight: Radius.circular(12),
    );

    return Column(
      crossAxisAlignment: align,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: radius,
          ),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 48.0),
                child: Text(message.text),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Row(
                  children: <Widget>[
                    Text(
                      message.timestamp.toLocal().toString(),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 10,
                      ),
                    ),
                    SizedBox(width: 8),
                    if (icon != null)
                      Icon(
                        icon,
                        size: 12,
                        color: Colors.grey[600],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
