class Passage {
  Passage({
    required this.book,
    required this.chapter,
    required this.verseStart,
    required this.verseEnd,
    required this.categories,
  });

  final String book;
  final String chapter;
  final String verseStart;
  final String verseEnd;
  final List<int> categories;

  Passage copyWith({
    String? book,
    String? chapter,
    String? verseStart,
    String? verseEnd,
    List<int>? categories,
  }) =>
      Passage(
        book: book ?? this.book,
        chapter: chapter ?? this.chapter,
        verseStart: verseStart ?? this.verseStart,
        verseEnd: verseEnd ?? this.verseEnd,
        categories: categories ?? this.categories,
      );

  factory Passage.fromJson(Map<String, dynamic> json) => Passage(
        book: json["book"],
        chapter: json["chapter"],
        verseStart: json["verse_start"],
        verseEnd: json["verse_end"],
        categories: List<int>.from(json["categories"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "book": book,
        "chapter": chapter,
        "verse_start": verseStart,
        "verse_end": verseEnd,
        "categories": List<dynamic>.from(categories.map((x) => x)),
      };
}
