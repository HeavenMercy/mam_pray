import 'dart:io';
import 'dart:convert';
import 'dart:async';

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
    this.lastPassageId = -1,
  });

  String firstname;
  int lastCategoryId;
  int lastPassageId;
  List<PassageCategory> categories;
  List<Passage> passages;

  void fillFrom(AppModel other, {bool listen = true}) {
    firstname = other.firstname;
    lastCategoryId = other.lastCategoryId;
    categories = other.categories.where((element) => true).toList();
    passages = other.passages.where((element) => true).toList();

    if (listen) notifyListeners();
  }

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

  Iterable<PassageCategory> getActiveCategories({bool sortByName = false}) {
    var ret = <PassageCategory>[];

    for (var passage in passages) {
      for (var categoryId in passage.categories) {
        var category = getCategory(categoryId);
        if ((category.id != -1) && !ret.contains(category)) ret.add(category);
      }
    }

    if (sortByName) ret.sort((p1, p2) => p1.name.compareTo(p2.name));
    return ret;
  }

  void addCategory(String name, {bool canDelete = true}) {
    var nextCategoryid = lastCategoryId + 1;
    var category =
        PassageCategory(id: nextCategoryid, name: name, editable: canDelete);

    if (!categoryExists(category.name)) {
      lastCategoryId = nextCategoryid;
      categories.add(category);

      notifyListeners();
      save();
    }
  }

  void updateCategoryName(int id, String name) {
    var category = getCategory(id);

    if (category.id != -1) {
      category.name = name;
      notifyListeners();
      save();
    }
  }

  void deleteCategory(int id) {
    categories.removeWhere((category) => (category.id == id));

    for (var i = passages.length - 1; i >= 0; --i) {
      passages[i].categories.remove(id);
      if (passages[i].categories.isEmpty) passages.removeAt(i);
    }

    notifyListeners();
    save();
  }

  void tryNormalizeCategories() {
    for (var category in Values.starterCategories) {
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

  static Passage getEmptyPassage() {
    return Passage(
      book: '',
      categories: [],
      chapter: 1,
      creationDate: DateTime.now(),
      id: -1,
      text: '',
      verseStart: 1,
      verseEnd: 1,
      viewCount: 1,
    );
  }

  void fillPassage(Passage passage, Passage other) {
    passage.fillFrom(other);
    notifyListeners();
    save();
  }

  int getNextPassageId() => ++lastPassageId;

  bool passageExists(Passage passage) {
    return passages.any((e) {
      return (Utils.isSameString(e.book, passage.book) &&
          (e.chapter == passage.chapter) &&
          (e.verseStart == passage.verseStart) &&
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

  bool addPassage(Passage passage) {
    if (passageExists(passage)) return false;

    passage.id = lastPassageId + 1;
    passage.creationDate = DateTime.now();
    passages.add(passage);

    notifyListeners();
    save();

    return true;
  }

  void deletePassage(int id) {
    passages.removeWhere((passage) => passage.id == id);

    notifyListeners();
    save();
  }

  void viewPassage(Passage passage) {
    passage.viewCount += 1;

    notifyListeners();
    save();
  }

  // FILE MANAGEMENT

  static Future<File> get _localFile async {
    final directory = await getTemporaryDirectory();
    return File('${directory.path}/mam_save.json');
  }

  Future<bool> load() async {
    AppModel model;
    var done = false;

    try {
      var file = await _localFile;
      var str = await file.readAsString();

      model = AppModel.fromJson(json.decode(str));
      done = true;
    } catch (exception) {
      model = AppModel(firstname: '', categories: [], passages: []);
    }

    model.tryNormalizeCategories();
    fillFrom(model);
    return done;
  }

  Future<bool> save() async {
    try {
      var file = await _localFile;
      var str = json.encode(toJson());

      await file.writeAsString(str);

      return true;
    } catch (exception) {
      return false;
    }
  }
}
