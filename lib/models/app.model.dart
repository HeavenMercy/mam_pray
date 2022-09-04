import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:mam_pray/config/values.config.dart';
import 'package:mam_pray/utils.dart';
import 'package:path_provider/path_provider.dart';

import 'category.model.dart';
import 'passage.model.dart';

class AppModel extends ChangeNotifier {
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

  // CATEGORY MANAGEMENT

  bool categoryExists(String name) {
    return categories.any((category) {
      return Utils.isSameString(category.name, name);
    });
  }

  PassageCategory getCategory(int id) {
    return categories.firstWhere((category) => category.id == id,
        orElse: () => PassageCategory(id: -1, name: ''));
  }

  void addCategory(String name, {bool canDelete = true}) {
    var nextCategoryid = lastCategoryId + 1;
    var category =
        PassageCategory(id: nextCategoryid, name: name, editable: canDelete);

    if (!categoryExists(category.name)) {
      lastCategoryId = nextCategoryid;
      categories.add(category);
      notifyListeners();
    }
  }

  void updateCategoryName(int id, String name) {
    var category = getCategory(id);

    if (category.id != -1) {
      categories.remove(category);
      categories.add(category.copyWith(name: name));
      notifyListeners();
    }
  }

  void deleteCategory(int id) {
    categories.removeWhere((category) => (category.id == id));
    notifyListeners();
  }

  void tryNormalizeCategories() {
    for (var category in Values.basicCategories) {
      addCategory(category, canDelete: false);
    }
  }

  List<PassageCategory> findCategories(String name) {
    return categories
        .where((category) =>
            category.name.toLowerCase().contains(name.toLowerCase()))
        .toList();
  }

  // PASSAGE MANAGEMENT

  bool passageExists(Passage passage) {
    return passages.any((e) {
      return (Utils.isSameString(e.book, passage.book) ||
          (e.chapter == passage.chapter) ||
          (e.verseStart == passage.verseStart) ||
          (e.verseEnd == passage.verseEnd));
    });
  }

  List<Passage> getTopPassages() {
    if (passages.length < Values.minCountForTop) return [];

    var top = passages.map((e) => e).toList(growable: false);
    top.sort((a, b) => b.viewCount.compareTo(a.viewCount));
    return top.sublist(0, Values.topPassageCount);
  }

  List<Passage> getPassages() {
    var passages = this.passages.map((e) => e).toList(growable: false);
    passages.sort((a, b) => b.viewCount.compareTo(a.viewCount));
    return passages;
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
      model = AppModel(firstname: '', categories: [], passages: <Passage>[
        Passage(
            book: 'book',
            chapter: 10,
            verseStart: 1,
            verseEnd: 5,
            viewCount: 2,
            categories: [1, 2, 8]),
        Passage(
            book: 'Epitre Selon St Paul',
            chapter: 10,
            verseStart: 1,
            verseEnd: 5,
            viewCount: 8,
            categories: [1, 2, 8]),
        Passage(
            book: 'Epitre Selon St Paul',
            chapter: 10,
            verseStart: 1,
            verseEnd: 5,
            viewCount: 8,
            categories: [1, 2, 8]),
        Passage(
            book: 'Epitre Selon St Paul',
            chapter: 10,
            verseStart: 1,
            verseEnd: 5,
            viewCount: 8,
            categories: [1, 2, 8]),
        Passage(
            book: 'book',
            chapter: 10,
            verseStart: 1,
            verseEnd: 5,
            viewCount: 5,
            categories: [1, 2, 8]),
        Passage(
            book: 'book',
            chapter: 10,
            verseStart: 1,
            verseEnd: 5,
            viewCount: 1,
            categories: [1, 2, 8]),
        Passage(
            book: 'book',
            chapter: 10,
            verseStart: 1,
            verseEnd: 5,
            viewCount: 6,
            categories: [1, 2, 8]),
        Passage(
            book: 'book',
            chapter: 10,
            verseStart: 1,
            verseEnd: 5,
            viewCount: 22,
            categories: [1, 2, 8]),
        Passage(
            book: 'book',
            chapter: 10,
            verseStart: 1,
            verseEnd: 5,
            viewCount: 12,
            categories: [1, 2, 8]),
        Passage(
            book: 'book',
            chapter: 10,
            verseStart: 1,
            verseEnd: 5,
            viewCount: 9,
            categories: [1, 2, 8]),
      ]);
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
