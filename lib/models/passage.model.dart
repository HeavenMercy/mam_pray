class Passage {
  Passage({
    required this.id,
    required this.book,
    required this.chapter,
    required this.verseStart,
    required this.categories,
    required this.creationDate,
    required this.text,
    this.viewCount = 0,
    this.verseEnd = -1,
  });

  int id;
  String book;
  int chapter;
  int verseStart;
  int verseEnd;
  int viewCount;
  String text;
  List<int> categories;
  DateTime creationDate;

  void fillFrom(Passage other) {
    if (id != other.id) return;

    book = other.book.trim();
    chapter = other.chapter;
    verseStart = other.verseStart;
    verseEnd = other.verseEnd;
    viewCount = other.viewCount;
    text = other.text.trim();
    categories = other.categories.where((_) => true).toList();
    creationDate = other.creationDate;
  }

  Passage copyWith({
    int? id,
    String? book,
    int? chapter,
    int? verseStart,
    int? verseEnd,
    int? viewCount,
    String? text,
    List<int>? categories,
    DateTime? creationDate,
  }) =>
      Passage(
          id: id ?? this.id,
          book: book ?? this.book,
          chapter: chapter ?? this.chapter,
          verseStart: verseStart ?? this.verseStart,
          verseEnd: verseEnd ?? this.verseEnd,
          viewCount: viewCount ?? this.viewCount,
          text: text ?? this.text,
          categories: categories ?? this.categories.where((_) => true).toList(),
          creationDate: creationDate ?? this.creationDate);

  factory Passage.fromJson(Map<String, dynamic> json) => Passage(
        id: json["id"],
        book: json["book"],
        chapter: json["chapter"],
        verseStart: json["verse_start"],
        verseEnd: json["verse_end"],
        viewCount: json["view_count"],
        text: json["text"],
        categories: List<int>.from(json["categories"].map((x) => x)),
        creationDate:
            DateTime.tryParse(json["creation_date"]) ?? DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "book": book,
        "chapter": chapter,
        "verse_start": verseStart,
        "verse_end": verseEnd,
        "view_count": viewCount,
        "text": text,
        "categories": List<dynamic>.from(categories.map((x) => x)),
        "creation_date": creationDate.toIso8601String(),
      };
}
