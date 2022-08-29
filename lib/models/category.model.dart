class PassageCategory {
  PassageCategory({
    required this.id,
    required this.name,
    this.canDelete = false,
  });

  final int id;
  final String name;
  final bool canDelete;

  PassageCategory copyWith({
    int? id,
    String? name,
    bool? canDelete,
  }) =>
      PassageCategory(
        id: id ?? this.id,
        name: name ?? this.name,
        canDelete: canDelete ?? this.canDelete,
      );

  factory PassageCategory.fromJson(Map<String, dynamic> json) =>
      PassageCategory(
        id: json["id"],
        name: json["name"],
        canDelete: json["can_delete"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "can_delete": canDelete,
      };
}
