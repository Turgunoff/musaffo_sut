import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  // Hozircha icon_name kerak emas, keyinroq qo'shamiz

  Category({required this.id, required this.name});

  // Supabase'dan kelgan Map'ni Category obyektiga aylantiradi
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(id: json['id'] as String, name: json['name'] as String);
  }
}
