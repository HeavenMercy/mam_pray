import 'dart:convert';
import 'dart:io';

import 'package:mam_pray/config/values.config.dart';
import 'package:mam_pray/utils.dart';
import 'package:path_provider/path_provider.dart';

import 'category.model.dart';
import 'passage.model.dart';

class AppModel {
  AppModel({
    required this.firstname,
    required this.categories,
    required this.passages,
    this.lastCategoryId = -1,
  });

  String firstname;
  int lastCategoryId;
  final List<PassageCategory> categories;
  final List<Passage> passages;

  AppModel copyWith({
    String? firstname,
    int? lastCategoryId,
    List<PassageCategory>? categories,
    List<Passage>? passages,
  }) =>
      AppModel(
        firstname: firstname ?? this.firstname,
        lastCategoryId: lastCategoryId ?? this.lastCategoryId,
        categories: categories ?? this.categories,
        passages: passages ?? this.passages,
      );

  factory AppModel.fromJson(Map<String, dynamic> json) => AppModel(
        firstname: json["firstname"],
        lastCategoryId: json["lastCategoryID"],
        categories: List<PassageCategory>.from(
            json["categories"].map((x) => PassageCategory.fromJson(x))),
        passages: List<Passage>.from(
            json["passages"].map((x) => Passage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "firstname": firstname,
        "lastCategoryID": lastCategoryId,
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
        "passages": List<dynamic>.from(passages.map((x) => x.toJson())),
      };

  bool categoryExists(PassageCategory category) {
    return categories.any((e) {
      return Utils.isSameString(e.name, category.name);
    });
  }

  bool addCategory(String name, {bool canDelete = true}) {
    var category = PassageCategory(
        id: (lastCategoryId + 1), name: name, canDelete: canDelete);

    if (!categoryExists(category)) {
      lastCategoryId += 1;
      categories.add(category);
      return true;
    }

    return false;
  }

  void tryNormalizeCategories() {
    for (var category in Values.basicCategories) {
      addCategory(category, canDelete: false);
    }
  }

  bool passageExists(Passage passage) {
    return passages.any((e) {
      return (Utils.isSameString(e.book, passage.book) ||
          (e.chapter == passage.chapter) ||
          (e.verseStart == passage.verseStart) ||
          (e.verseEnd == passage.verseEnd));
    });
  }

  // FILE MANAGEMENT

  static Future<File> get _localFile async {
    final directory = await getTemporaryDirectory();
    if (!(await directory.exists())) await directory.create(recursive: true);
    print('loading $directory...');
    return File('${directory.path}/mam_save.json');
  }

  static Future<AppModel> load() async {
    AppModel model;

    try {
      var file = await _localFile;
      var str = await file.readAsString();

      model = AppModel.fromJson(json.decode(str));
      print('loaded $model');
    } catch (exception) {
      model = AppModel(firstname: '', categories: [], passages: []);
      print('default model created...');
    }

    model.tryNormalizeCategories();
    return model;
  }

  Future<bool> save() async {
    try {
      var file = await _localFile;
      var str = json.encode(toJson());

      await file.writeAsString(str);

      print('saving in ${file.uri} => $str');
      return true;
    } catch (exception) {
      return false;
    }
  }
}
