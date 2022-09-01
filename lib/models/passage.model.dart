class Passage {
  Passage({
    required this.book,
    required this.chapter,
    required this.verseStart,
    required this.verseEnd,
    required this.categories,
    this.viewCount = 0,
  });

  final String book;
  final int chapter;
  final int verseStart;
  final int verseEnd;
  final int viewCount;
  final List<int> categories;

  Passage copyWith({
    String? book,
    int? chapter,
    int? verseStart,
    int? verseEnd,
    int? viewCount,
    List<int>? categories,
  }) =>
      Passage(
        book: book ?? this.book,
        chapter: chapter ?? this.chapter,
        verseStart: verseStart ?? this.verseStart,
        verseEnd: verseEnd ?? this.verseEnd,
        viewCount: viewCount ?? this.viewCount,
        categories: categories ?? this.categories,
      );

  factory Passage.fromJson(Map<String, dynamic> json) => Passage(
        book: json["book"],
        chapter: json["chapter"],
        verseStart: json["verse_start"],
        verseEnd: json["verse_end"],
        viewCount: json["view_count"],
        categories: List<int>.from(json["categories"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "book": book,
        "chapter": chapter,
        "verse_start": verseStart,
        "verse_end": verseEnd,
        "view_count": viewCount,
        "categories": List<dynamic>.from(categories.map((x) => x)),
      };
}
