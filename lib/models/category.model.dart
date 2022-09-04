class PassageCategory {
  PassageCategory({
    required this.id,
    required this.name,
    this.editable = false,
  });

  final int id;
  final String name;
  final bool editable;

  PassageCategory copyWith({
    int? id,
    String? name,
    bool? editable,
  }) =>
      PassageCategory(
        id: id ?? this.id,
        name: name ?? this.name,
        editable: editable ?? this.editable,
      );

  factory PassageCategory.fromJson(Map<String, dynamic> json) =>
      PassageCategory(
        id: json["id"],
        name: json["name"],
        editable: json["editable"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "editable": editable,
      };
}
