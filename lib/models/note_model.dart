import 'package:flutter/foundation.dart';

class Note {
  final int? id;
  final String title;
  final String content;
  final bool isVoice;

  Note({
    this.id,
    required this.title,
    required this.content,
    this.isVoice = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'isVoice': isVoice ? 1 : 0,
    };
  }
}
