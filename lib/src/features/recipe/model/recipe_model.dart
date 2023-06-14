// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

class SavedIngredients {
  final String id;
  final DateTime tanggalMasuk;
  final int quantity;
  SavedIngredients({
    required this.id,
    required this.tanggalMasuk,
    required this.quantity,
  });

  SavedIngredients copyWith({
    String? id,
    DateTime? tanggalMasuk,
    int? quantity,
  }) {
    return SavedIngredients(
      id: id ?? this.id,
      tanggalMasuk: tanggalMasuk ?? this.tanggalMasuk,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'tanggalMasuk': tanggalMasuk.millisecondsSinceEpoch,
      'quantity': quantity,
    };
  }

  factory SavedIngredients.fromMap(Map<String, dynamic> map) {
    return SavedIngredients(
      id: map['id'] as String,
      tanggalMasuk:
          DateTime.fromMillisecondsSinceEpoch(map['tanggalMasuk'] as int),
      quantity: map['quantity'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory SavedIngredients.fromJson(String source) =>
      SavedIngredients.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'SavedIngredients(id: $id, tanggalMasuk: $tanggalMasuk, quantity: $quantity)';

  @override
  bool operator ==(covariant SavedIngredients other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.tanggalMasuk == tanggalMasuk &&
        other.quantity == quantity;
  }

  @override
  int get hashCode => id.hashCode ^ tanggalMasuk.hashCode ^ quantity.hashCode;
}

class User {
  final String id;
  final String name;
  final String desc;
  final List<String> createdRecipe;
  final List<String> favoriteRecipe;
  final List<SavedIngredients> savedIngredients;
  final int totalPoint;
  final DateTime tanggalJoin;
  final String? profileUrl;
  User({
    required this.id,
    required this.name,
    required this.desc,
    required this.createdRecipe,
    required this.favoriteRecipe,
    required this.savedIngredients,
    required this.totalPoint,
    required this.tanggalJoin,
    this.profileUrl,
  });

  User copyWith({
    String? id,
    String? name,
    List<String>? createdRecipe,
    List<String>? favoriteRecipe,
    List<SavedIngredients>? savedIngredients,
    int? totalPoint,
    DateTime? tanggalJoin,
    String? profileUrl,
    String? desc,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      createdRecipe: createdRecipe ?? this.createdRecipe,
      favoriteRecipe: favoriteRecipe ?? this.favoriteRecipe,
      savedIngredients: savedIngredients ?? this.savedIngredients,
      totalPoint: totalPoint ?? this.totalPoint,
      tanggalJoin: tanggalJoin ?? this.tanggalJoin,
      profileUrl: profileUrl ?? this.profileUrl,
      desc: desc ?? this.desc,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'createdRecipe': createdRecipe,
      'favoriteRecipe': favoriteRecipe,
      'savedIngredients': savedIngredients.map((x) => x.toMap()).toList(),
      'totalPoint': totalPoint,
      'tanggalJoin': tanggalJoin.millisecondsSinceEpoch,
      'profileUrl': profileUrl,
      'desc': desc,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      desc: map["desc"] ?? "",
      savedIngredients: loadFromNullable(map["savedIngredients"])
          .cast<Map<String, dynamic>>()
          .map((e) => SavedIngredients.fromMap(e))
          .toList(),
      id: map['id'] as String,
      name: map['name'] as String,
      createdRecipe: List<String>.from(
          map['createdRecipe'] != null ? map['createdRecipe'] as List : []),
      favoriteRecipe: List<String>.from(
          map['favoriteRecipe'] != null ? map['favoriteRecipe'] as List : []),
      totalPoint: map['totalPoint'] as int,
      profileUrl: map["profileUrl"] as String?,
      tanggalJoin: DateTime.fromMillisecondsSinceEpoch(map['tanggalJoin']),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $id, name: $name, desc: $desc, createdRecipe: $createdRecipe, favoriteRecipe: $favoriteRecipe, savedIngredients: $savedIngredients, totalPoint: $totalPoint, tanggalJoin: $tanggalJoin, profileUrl: $profileUrl)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        listEquals(other.createdRecipe, createdRecipe) &&
        listEquals(other.favoriteRecipe, favoriteRecipe) &&
        listEquals(other.savedIngredients, savedIngredients) &&
        other.totalPoint == totalPoint &&
        other.tanggalJoin == tanggalJoin &&
        other.profileUrl == profileUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        createdRecipe.hashCode ^
        favoriteRecipe.hashCode ^
        savedIngredients.hashCode ^
        totalPoint.hashCode ^
        tanggalJoin.hashCode ^
        profileUrl.hashCode;
  }
}

class RecipeModel {
  final String id;
  final String recipeName;
  final String authorId;
  final String authorName;
  final num rating;
  final List<Reviews> reviews;
  final num calories;
  final List<Steps> steps;
  final List<IngredientRecipe> ingredientList;
  final int totalLikes;
  final List<String> categoriesList;
  final num timeNeeded;
  final String timeFormat;

  final String fileUrl;

  RecipeModel({
    required this.id,
    required this.recipeName,
    required this.authorId,
    required this.authorName,
    required this.rating,
    required this.reviews,
    required this.calories,
    required this.steps,
    required this.ingredientList,
    required this.totalLikes,
    required this.categoriesList,
    required this.timeNeeded,
    required this.timeFormat,
    required this.fileUrl,
  });

  RecipeModel copyWith({
    String? id,
    String? recipeName,
    String? authorId,
    String? authorName,
    num? rating,
    List<Reviews>? reviews,
    num? calories,
    List<Steps>? steps,
    List<IngredientRecipe>? ingredientList,
    int? totalLikes,
    List<String>? categoriesList,
    num? timeNeeded,
    String? timeFormat,
    String? fileUrl,
  }) {
    return RecipeModel(
      id: id ?? this.id,
      recipeName: recipeName ?? this.recipeName,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      rating: rating ?? this.rating,
      reviews: reviews ?? this.reviews,
      calories: calories ?? this.calories,
      steps: steps ?? this.steps,
      ingredientList: ingredientList ?? this.ingredientList,
      totalLikes: totalLikes ?? this.totalLikes,
      categoriesList: categoriesList ?? this.categoriesList,
      timeNeeded: timeNeeded ?? this.timeNeeded,
      timeFormat: timeFormat ?? this.timeFormat,
      fileUrl: fileUrl ?? this.fileUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'recipeName': recipeName,
      'authorId': authorId,
      'authorName': authorName,
      'rating': rating,
      'reviews': reviews.map((x) => x.toMap()).toList(),
      'calories': calories,
      'steps': steps.map((x) => x.toMap()).toList(),
      'ingredientList': ingredientList.map((x) => x.toMap()).toList(),
      'totalLikes': totalLikes,
      'categoriesList': categoriesList,
      'timeNeeded': timeNeeded,
      'timeFormat': timeFormat,
      'fileUrl': fileUrl,
    };
  }

  factory RecipeModel.fromMap(Map<String, dynamic> map) {
    return RecipeModel(
      calories: map["calories"],
      categoriesList: (map['categoriesList'] != null
              ? map['categoriesList'] as List
              : List.empty())
          .cast<String>(),
      timeFormat: map['timeFormat'] as String? ?? "hours",
      timeNeeded: map['timeNeeded'] as num? ?? 1,
      fileUrl: map["fileUrl"] as String,
      id: map['id'] as String,
      recipeName: map['recipeName'] as String,
      authorId: map['authorId'] as String,
      authorName: map['authorName'] as String,
      rating: map['rating'] as num,
      reviews: (map['reviews'] != null ? map['reviews'] as List : List.empty())
          .cast<Map<String, dynamic>>()
          .map((e) => Reviews.fromMap(e))
          .toList(),
      steps: (map['steps'] != null ? map['steps'] as List : List.empty())
          .cast<Map<String, dynamic>>()
          .map((e) => Steps.fromMap(e))
          .toList(),
      ingredientList: (map['ingredientList'] != null
              ? map['ingredientList'] as List
              : List.empty())
          .cast<Map<String, dynamic>>()
          .map((e) => IngredientRecipe.fromMap(e))
          .toList(),
      totalLikes: map['totalLikes'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory RecipeModel.fromJson(String source) =>
      RecipeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RecipeModel(id: $id, recipeName: $recipeName, authorId: $authorId, authorName: $authorName, rating: $rating, reviews: $reviews, calories: $calories, steps: $steps, ingredientList: $ingredientList, totalLikes: $totalLikes, categoriesList: $categoriesList, timeNeeded: $timeNeeded, timeFormat: $timeFormat, fileUrl: $fileUrl)';
  }

  @override
  bool operator ==(covariant RecipeModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.recipeName == recipeName &&
        other.authorId == authorId &&
        other.authorName == authorName &&
        other.rating == rating &&
        listEquals(other.reviews, reviews) &&
        other.calories == calories &&
        listEquals(other.steps, steps) &&
        listEquals(other.ingredientList, ingredientList) &&
        other.totalLikes == totalLikes &&
        listEquals(other.categoriesList, categoriesList) &&
        other.timeNeeded == timeNeeded &&
        other.timeFormat == timeFormat &&
        other.fileUrl == fileUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        recipeName.hashCode ^
        authorId.hashCode ^
        authorName.hashCode ^
        rating.hashCode ^
        reviews.hashCode ^
        calories.hashCode ^
        steps.hashCode ^
        ingredientList.hashCode ^
        totalLikes.hashCode ^
        categoriesList.hashCode ^
        timeNeeded.hashCode ^
        timeFormat.hashCode ^
        fileUrl.hashCode;
  }
}

class IngredientRecipe {
  final String ingredientId;
  final String name;
  final num quantity;
  final String unit;
  IngredientRecipe({
    required this.ingredientId,
    required this.name,
    required this.quantity,
    required this.unit,
  });

  IngredientRecipe copyWith({
    String? ingredientId,
    String? name,
    num? quantity,
    String? unit,
  }) {
    return IngredientRecipe(
      ingredientId: ingredientId ?? this.ingredientId,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'ingredientId': ingredientId,
      'name': name,
      'quantity': quantity,
      'unit': unit,
    };
  }

  factory IngredientRecipe.fromMap(Map<String, dynamic> map) {
    return IngredientRecipe(
      ingredientId: map['ingredientId'] as String,
      name: map['name'] as String,
      quantity: map['quantity'] as num,
      unit: map['unit'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory IngredientRecipe.fromJson(String source) =>
      IngredientRecipe.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'IngredientRecipe(ingredientId: $ingredientId, name: $name, quantity: $quantity, unit: $unit)';
  }

  @override
  bool operator ==(covariant IngredientRecipe other) {
    if (identical(this, other)) return true;

    return other.ingredientId == ingredientId &&
        other.name == name &&
        other.quantity == quantity &&
        other.unit == unit;
  }

  @override
  int get hashCode {
    return ingredientId.hashCode ^
        name.hashCode ^
        quantity.hashCode ^
        unit.hashCode;
  }
}

class Ingredients {
  final String id;
  final String ingredientName;
  final num shelfTime;
  final String shelftUnit;
  final String unit;
  final String description;

  Ingredients({
    required this.id,
    required this.ingredientName,
    required this.shelfTime,
    required this.shelftUnit,
    required this.unit,
    required this.description,
  });

  Ingredients copyWith({
    String? id,
    String? ingredientName,
    num? shelfTime,
    String? shelftUnit,
    String? unit,
    String? description,
  }) {
    return Ingredients(
      id: id ?? this.id,
      ingredientName: ingredientName ?? this.ingredientName,
      shelfTime: shelfTime ?? this.shelfTime,
      shelftUnit: shelftUnit ?? this.shelftUnit,
      unit: unit ?? this.unit,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'ingredientName': ingredientName,
      'shelfTime': shelfTime,
      'shelftUnit': shelftUnit,
      'unit': unit,
      'description': description,
    };
  }

  factory Ingredients.fromMap(Map<String, dynamic> map) {
    return Ingredients(
      id: map['id'] as String,
      ingredientName: map['ingredientName'] as String,
      shelfTime: map['shelfTime'] as num,
      shelftUnit: map['shelftUnit'] as String,
      unit: map['unit'] as String,
      description: map['description'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Ingredients.fromJson(String source) =>
      Ingredients.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Ingredients(id: $id, ingredientName: $ingredientName, shelfTime: $shelfTime, shelftUnit: $shelftUnit, unit: $unit, description: $description)';
  }

  @override
  bool operator ==(covariant Ingredients other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.ingredientName == ingredientName &&
        other.shelfTime == shelfTime &&
        other.shelftUnit == shelftUnit &&
        other.unit == unit &&
        other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        ingredientName.hashCode ^
        shelfTime.hashCode ^
        shelftUnit.hashCode ^
        unit.hashCode ^
        description.hashCode;
  }
}

class Reviews {
  final String desc;
  final String userId;
  Reviews({
    required this.desc,
    required this.userId,
  });

  Reviews copyWith({
    String? desc,
    String? userId,
  }) {
    return Reviews(
      desc: desc ?? this.desc,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'desc': desc,
      'userId': userId,
    };
  }

  factory Reviews.fromMap(Map<String, dynamic> map) {
    return Reviews(
      desc: map['desc'] as String,
      userId: map['userId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Reviews.fromJson(String source) =>
      Reviews.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Reviews(desc: $desc, userId: $userId)';

  @override
  bool operator ==(covariant Reviews other) {
    if (identical(this, other)) return true;

    return other.desc == desc && other.userId == userId;
  }

  @override
  int get hashCode => desc.hashCode ^ userId.hashCode;
}

class Steps {
  final String desc;
  final String fileUrl;
  final String id;
  final File? file;
  Steps({
    required this.desc,
    required this.fileUrl,
    required this.id,
    this.file,
  });

  Steps copyWith({
    String? desc,
    String? fileUrl,
    String? id,
  }) {
    return Steps(
      desc: desc ?? this.desc,
      fileUrl: fileUrl ?? this.fileUrl,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'desc': desc,
      'fileUrl': fileUrl,
    };
  }

  factory Steps.fromMap(Map<String, dynamic> map) {
    return Steps(
      desc: map['desc'] as String,
      fileUrl: map['fileUrl'] as String,
      id: "",
    );
  }

  String toJson() => json.encode(toMap());

  factory Steps.fromJson(String source) =>
      Steps.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Steps(desc: $desc, fileUrl: $fileUrl, id: $id)';

  @override
  bool operator ==(covariant Steps other) {
    if (identical(this, other)) return true;

    return other.desc == desc && other.fileUrl == fileUrl && other.id == id;
  }

  @override
  int get hashCode => desc.hashCode ^ fileUrl.hashCode ^ id.hashCode;
}

List loadFromNullable(dynamic data) {
  return data ?? [];
}
