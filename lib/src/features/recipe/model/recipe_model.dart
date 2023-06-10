// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class User {
  final String id;
  final String name;
  final List<String> createdRecipe;
  final List<String> favoriteRecipe;
  final int totalPoint;
  final DateTime tanggalJoin;
  User({
    required this.id,
    required this.name,
    required this.createdRecipe,
    required this.favoriteRecipe,
    required this.totalPoint,
    required this.tanggalJoin,
  });

  User copyWith({
    String? id,
    String? name,
    List<String>? createdRecipe,
    List<String>? favoriteRecipe,
    int? totalPoint,
    DateTime? tanggalJoin,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      createdRecipe: createdRecipe ?? this.createdRecipe,
      favoriteRecipe: favoriteRecipe ?? this.favoriteRecipe,
      totalPoint: totalPoint ?? this.totalPoint,
      tanggalJoin: tanggalJoin ?? this.tanggalJoin,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'createdRecipe': createdRecipe,
      'favoriteRecipe': favoriteRecipe,
      'totalPoint': totalPoint,
      'tanggalJoin': tanggalJoin.millisecondsSinceEpoch,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      name: map['name'] as String,
      createdRecipe: List<String>.from(map['createdRecipe'] != null
          ? map['createdRecipe'] as List<String>
          : []),
      favoriteRecipe: List<String>.from(map['favoriteRecipe'] != null
          ? map['favoriteRecipe'] as List<String>
          : []),
      totalPoint: map['totalPoint'] as int,
      tanggalJoin: DateTime.fromMillisecondsSinceEpoch(map['tanggalJoin']),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $id, name: $name, createdRecipe: $createdRecipe, favoriteRecipe: $favoriteRecipe, totalPoint: $totalPoint, tanggalJoin: $tanggalJoin)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        listEquals(other.createdRecipe, createdRecipe) &&
        listEquals(other.favoriteRecipe, favoriteRecipe) &&
        other.totalPoint == totalPoint &&
        other.tanggalJoin == tanggalJoin;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        createdRecipe.hashCode ^
        favoriteRecipe.hashCode ^
        totalPoint.hashCode ^
        tanggalJoin.hashCode;
  }
}

class RecipeModel {
  final String id;
  final String recipeName;
  final String authorId;
  final String authorName;
  final num rating;
  final List<Reviews> reviews;
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
      'steps': steps.map((x) => x.toMap()).toList(),
      'ingredientList': ingredientList.map((x) => x.toMap()).toList(),
      'totalLikes': totalLikes,
      'fileUrl': fileUrl,
      'categoriesList': categoriesList,
      'timeFormat': timeFormat,
      'timeNeeded': timeNeeded,
    };
  }

  factory RecipeModel.fromMap(Map<String, dynamic> map) {
    return RecipeModel(
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
    return 'RecipeModel(id: $id, recipeName: $recipeName, authorId: $authorId, authorName: $authorName, rating: $rating, reviews: $reviews, steps: $steps, ingredientList: $ingredientList, totalLikes: $totalLikes, categoriesList: $categoriesList, timeNeeded: $timeNeeded, timeFormat: $timeFormat, fileUrl: $fileUrl)';
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
  final num quantity;
  final String unit;
  IngredientRecipe({
    required this.ingredientId,
    required this.quantity,
    required this.unit,
  });

  IngredientRecipe copyWith({
    String? ingredientId,
    num? quantity,
    String? unit,
  }) {
    return IngredientRecipe(
      ingredientId: ingredientId ?? this.ingredientId,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'ingredientId': ingredientId,
      'quantity': quantity,
      'unit': unit,
    };
  }

  factory IngredientRecipe.fromMap(Map<String, dynamic> map) {
    return IngredientRecipe(
      ingredientId: map['ingredientId'] as String,
      quantity: map['quantity'] as num,
      unit: map['unit'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory IngredientRecipe.fromJson(String source) =>
      IngredientRecipe.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'IngredientRecipe(ingredientId: $ingredientId, quantity: $quantity, unit: $unit)';

  @override
  bool operator ==(covariant IngredientRecipe other) {
    if (identical(this, other)) return true;

    return other.ingredientId == ingredientId &&
        other.quantity == quantity &&
        other.unit == unit;
  }

  @override
  int get hashCode => ingredientId.hashCode ^ quantity.hashCode ^ unit.hashCode;
}

class Ingredients {
  final String id;
  final String ingredientName;

  Ingredients({
    required this.id,
    required this.ingredientName,
  });

  Ingredients copyWith({
    String? id,
    String? ingredientName,
  }) {
    return Ingredients(
      id: id ?? this.id,
      ingredientName: ingredientName ?? this.ingredientName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'ingredientName': ingredientName,
    };
  }

  factory Ingredients.fromMap(Map<String, dynamic> map) {
    return Ingredients(
      id: map['id'] as String,
      ingredientName: map['ingredientName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Ingredients.fromJson(String source) =>
      Ingredients.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Ingredients(id: $id, ingredientName: $ingredientName)';

  @override
  bool operator ==(covariant Ingredients other) {
    if (identical(this, other)) return true;

    return other.id == id && other.ingredientName == ingredientName;
  }

  @override
  int get hashCode => id.hashCode ^ ingredientName.hashCode;
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
  Steps({
    required this.desc,
    required this.fileUrl,
  });

  Steps copyWith({
    String? desc,
    String? fileUrl,
  }) {
    return Steps(
      desc: desc ?? this.desc,
      fileUrl: fileUrl ?? this.fileUrl,
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
    );
  }

  String toJson() => json.encode(toMap());

  factory Steps.fromJson(String source) =>
      Steps.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Steps(desc: $desc, fileUrl: $fileUrl)';

  @override
  bool operator ==(covariant Steps other) {
    if (identical(this, other)) return true;

    return other.desc == desc && other.fileUrl == fileUrl;
  }

  @override
  int get hashCode => desc.hashCode ^ fileUrl.hashCode;
}

List loadFromNullable(dynamic data) {
  return data ?? [];
}
