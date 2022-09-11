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
    this.lastPassageId = -1,
  });

  String firstname;
  int lastCategoryId;
  int lastPassageId;
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
      category.name = name;
      notifyListeners();
    }
  }

  void deleteCategory(int id) {
    passages.removeWhere((passage) => passage.categories.contains(id));
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
      viewCount: 0,
    );
  }

  void getNextPassageId() => ++lastPassageId;

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

  void deletePassage(int id) {
    passages.removeWhere((passage) => passage.id == id);
    notifyListeners();
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
            id: 1,
            book: 'book (with text)',
            chapter: 10,
            verseStart: 1,
            verseEnd: 5,
            viewCount: 2,
            text:
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Mauris ultrices eros in cursus. Eget mi proin sed libero enim sed faucibus turpis. Purus sit amet luctus venenatis lectus magna. Faucibus nisl tincidunt eget nullam non nisi est. Phasellus vestibulum lorem sed risus. Condimentum id venenatis a condimentum vitae sapien pellentesque habitant morbi. Amet nisl purus in mollis nunc sed. Dis parturient montes nascetur ridiculus. Nec tincidunt praesent semper feugiat nibh sed. Et molestie ac feugiat sed. Nunc consequat interdum varius sit amet mattis vulputate enim.\r\n\r\nGravida cum sociis natoque penatibus et magnis. Arcu dui vivamus arcu felis bibendum ut tristique et egestas. Enim nec dui nunc mattis. Dui nunc mattis enim ut. In ante metus dictum at tempor commodo ullamcorper a. Eget duis at tellus at urna. Sit amet nulla facilisi morbi tempus. Sagittis orci a scelerisque purus semper. Vitae sapien pellentesque habitant morbi tristique senectus et netus. Amet facilisis magna etiam tempor. Vitae tortor condimentum lacinia quis vel eros. Orci a scelerisque purus semper eget duis at. Et tortor at risus viverra adipiscing at in tellus integer. Cras ornare arcu dui vivamus arcu felis bibendum ut. Placerat orci nulla pellentesque dignissim enim sit amet.\r\n\r\nOrci a scelerisque purus semper eget duis at. Risus pretium quam vulputate dignissim suspendisse in est ante in. Magna sit amet purus gravida quis blandit. Posuere ac ut consequat semper viverra nam. Vel risus commodo viverra maecenas accumsan. Diam sit amet nisl suscipit adipiscing. Faucibus interdum posuere lorem ipsum dolor sit amet. Aliquet nibh praesent tristique magna sit amet. Netus et malesuada fames ac turpis egestas sed. Cursus eget nunc scelerisque viverra mauris in aliquam sem. Quam vulputate dignissim suspendisse in est ante in nibh mauris. Facilisis mauris sit amet massa vitae tortor condimentum lacinia. Tortor dignissim convallis aenean et. Mi quis hendrerit dolor magna. Duis convallis convallis tellus id interdum velit. Proin sed libero enim sed faucibus turpis in. Libero volutpat sed cras ornare. Morbi leo urna molestie at elementum eu.\r\n\r\nMi in nulla posuere sollicitudin aliquam. Egestas sed tempus urna et pharetra pharetra massa massa. Orci eu lobortis elementum nibh tellus molestie. Ac turpis egestas maecenas pharetra convallis posuere morbi. Nullam vehicula ipsum a arcu cursus. Id donec ultrices tincidunt arcu non. Aliquet sagittis id consectetur purus. Et malesuada fames ac turpis egestas integer. Lobortis feugiat vivamus at augue. In eu mi bibendum neque egestas congue quisque egestas. Nulla aliquet porttitor lacus luctus accumsan tortor. Enim ut tellus elementum sagittis vitae et leo. Ut venenatis tellus in metus vulputate. Eget dolor morbi non arcu risus.\r\n\r\nEst ullamcorper eget nulla facilisi etiam dignissim diam. Ornare arcu odio ut sem. Laoreet sit amet cursus sit amet dictum. Elit sed vulputate mi sit amet. Gravida neque convallis a cras semper auctor neque. Massa eget egestas purus viverra accumsan in. Massa eget egestas purus viverra accumsan. Dolor sit amet consectetur adipiscing. Tincidunt lobortis feugiat vivamus at augue eget arcu. Eu sem integer vitae justo eget magna fermentum iaculis eu. Vestibulum lorem sed risus ultricies tristique nulla aliquet enim. Ullamcorper eget nulla facilisi etiam dignissim diam quis. Consectetur lorem donec massa sapien faucibus et. Leo vel fringilla est ullamcorper. Turpis egestas maecenas pharetra convallis posuere morbi. Mauris sit amet massa vitae. Risus nec feugiat in fermentum posuere urna nec. Varius duis at consectetur lorem. Dolor sit amet consectetur adipiscing elit pellentesque.",
            categories: [1, 2, 8, 9, 3, 5, 4],
            creationDate: DateTime.now()),
        Passage(
            id: 2,
            book: 'Epitre Selon St Paul',
            chapter: 10,
            verseStart: 1,
            verseEnd: 5,
            viewCount: 8,
            text: "",
            categories: [1, 2, 8],
            creationDate: DateTime.now()),
        Passage(
            id: 3,
            book: 'Epitre Selon St Paul',
            chapter: 10,
            verseStart: 1,
            verseEnd: 5,
            viewCount: 8,
            text: "",
            categories: [1, 2, 8],
            creationDate: DateTime.now()),
        Passage(
            id: 4,
            book: 'Epitre selon st paul',
            chapter: 10,
            verseStart: 1,
            verseEnd: 5,
            viewCount: 8,
            text: "",
            categories: [1, 2, 8],
            creationDate: DateTime.now()),
        Passage(
            id: 5,
            book: 'book',
            chapter: 10,
            verseStart: 1,
            verseEnd: 5,
            viewCount: 5,
            text: "",
            categories: [1, 2, 8],
            creationDate: DateTime.now()),
        Passage(
            id: 6,
            book: 'book',
            chapter: 10,
            verseStart: 1,
            verseEnd: 5,
            viewCount: 1,
            text: "",
            categories: [1, 2, 8],
            creationDate: DateTime.now()),
        Passage(
            id: 7,
            book: 'book',
            chapter: 10,
            verseStart: 1,
            verseEnd: 5,
            viewCount: 6,
            text: "",
            categories: [1, 2, 8],
            creationDate: DateTime.now()),
        Passage(
            id: 8,
            book: 'book',
            chapter: 10,
            verseStart: 1,
            verseEnd: 5,
            viewCount: 22,
            text: "",
            categories: [1, 2, 8],
            creationDate: DateTime.now()),
        Passage(
            id: 9,
            book: 'book',
            chapter: 10,
            verseStart: 1,
            verseEnd: 5,
            viewCount: 12,
            text: "",
            categories: [1, 2, 8],
            creationDate: DateTime.now()),
        Passage(
            id: 10,
            book: 'book',
            chapter: 10,
            verseStart: 1,
            verseEnd: 5,
            viewCount: 9,
            text: "",
            categories: [1, 2, 8],
            creationDate: DateTime.now()),
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
