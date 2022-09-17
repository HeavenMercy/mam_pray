import 'dart:convert';

class BibleAPIResponse {
  BibleAPIResponse({
    required this.reference,
    required this.verses,
    required this.text,
    required this.translationId,
    required this.translationName,
    required this.translationNote,
  });

  final String reference;
  final List<Verse> verses;
  final String text;
  final String translationId;
  final String translationName;
  final String translationNote;

  BibleAPIResponse copyWith({
    String? reference,
    List<Verse>? verses,
    String? text,
    String? translationId,
    String? translationName,
    String? translationNote,
  }) =>
      BibleAPIResponse(
        reference: reference ?? this.reference,
        verses: verses ?? this.verses,
        text: text ?? this.text,
        translationId: translationId ?? this.translationId,
        translationName: translationName ?? this.translationName,
        translationNote: translationNote ?? this.translationNote,
      );

  factory BibleAPIResponse.fromJson(Map<String, dynamic> json) =>
      BibleAPIResponse(
        reference: json["reference"],
        verses: List<Verse>.from(json["verses"].map((x) => Verse.fromJson(x))),
        text: json["text"],
        translationId: json["translation_id"],
        translationName: json["translation_name"],
        translationNote: json["translation_note"],
      );

  Map<String, dynamic> toJson() => {
        "reference": reference,
        "verses": List<dynamic>.from(verses.map((x) => x.toJson())),
        "text": text,
        "translation_id": translationId,
        "translation_name": translationName,
        "translation_note": translationNote,
      };

  static BibleAPIResponse fromRawJson(String str) =>
      BibleAPIResponse.fromJson(json.decode(str));

  static String toRawJson(BibleAPIResponse data) => json.encode(data.toJson());
}

class Verse {
  Verse({
    required this.bookId,
    required this.bookName,
    required this.chapter,
    required this.verse,
    required this.text,
  });

  final String bookId;
  final String bookName;
  final int chapter;
  final int verse;
  final String text;

  Verse copyWith({
    String? bookId,
    String? bookName,
    int? chapter,
    int? verse,
    String? text,
  }) =>
      Verse(
        bookId: bookId ?? this.bookId,
        bookName: bookName ?? this.bookName,
        chapter: chapter ?? this.chapter,
        verse: verse ?? this.verse,
        text: text ?? this.text,
      );

  factory Verse.fromJson(Map<String, dynamic> json) => Verse(
        bookId: json["book_id"],
        bookName: json["book_name"],
        chapter: json["chapter"],
        verse: json["verse"],
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "book_id": bookId,
        "book_name": bookName,
        "chapter": chapter,
        "verse": verse,
        "text": text,
      };
}
