import 'package:flutter/material.dart';

import '../global_string.dart';

class Curriculum {
  final int id;
  final String subject;
  final String week;
  final String objectives;
  final String classTag;

  Curriculum(
      {required this.id,
      required this.subject,
      required this.week,
      required this.objectives,
      required this.classTag});
}

class cartNote {
  final String cart;
  cartNote({required this.cart});
}

class dashNote {
  final String title, content, end, info, details;

  dashNote(
      {required this.title,
      required this.content,
      required this.end,
      required this.info,
      required this.details});

  factory dashNote.fromJson(Map<String, dynamic> json) {
    return dashNote(
        title: json[ttl],
        content: json[cnt],
        end: json[syp],
        info: json[sbj],
        details: json[dtl]);
  }
}

class balance {
  final String bal;
  balance({required this.bal});
}

class userDtlz {
  final String nmm;
  userDtlz({required this.nmm});
}

class broadcast {
  final String caption, cta, image;

  broadcast({required this.caption, required this.cta, required this.image});
}

class category {
  final String text, selected;
  category({required this.text, required this.selected});
}

class dropDownlst {
  final String id;
  final List<String> array;
  dropDownlst({required this.id, required this.array});
}

class contentMode {
  final String content;
  contentMode({required this.content});
}

class stackStar {
  final String char;
  stackStar({required this.char});
}

class liveNote {
  final String note;
  final String body;

  liveNote({required this.note, required this.body});
}

class comboNote {
  final String note;
  final String select;

  comboNote({required this.note, required this.select});
}

class liveSession {
  final String link;
  liveSession({required this.link});
}

class NoticeList {
  final List<Notice> notify;
  NoticeList({required this.notify});
}

class serverFile {
  final String filePath;
  final bool status;
  serverFile({required this.filePath, required this.status});
}

class Notice {
  final int id;
  final String title, caption, content, detail;

  Notice(
      {required this.id,
      required this.title,
      required this.caption,
      required this.content,
      required this.detail});

  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
        id: json[id_],
        title: json[ttl],
        content: json[cnt],
        detail: json[dtl],
        caption: cpt);
  }
}
