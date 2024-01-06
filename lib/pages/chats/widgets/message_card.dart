import 'package:convo/config/theme.dart';
import 'package:flutter/material.dart';

class MessageOut extends StatelessWidget {
  final String message;
  const MessageOut({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            '19.07',
            style: regularTS.copyWith(fontSize: 12),
          ),
          const SizedBox(
            width: 12,
          ),
          Container(
            width: MediaQuery.of(context).size.width / 2,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(20),
              ),
              color: blue,
            ),
            child: Text(
              message,
              style: regularTS.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageIn extends StatelessWidget {
  final String message;
  const MessageIn({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 2,
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(20),
              ),
              color: Colors.white,
            ),
            child: Text(
              message,
              style: regularTS,
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Text(
            '19.07',
            style: regularTS.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
