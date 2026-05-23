import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../model/budget_model.dart';
import '../repository/category_repository.dart';

final _categoryRepositoryProvider = Provider((_) => CategoryRepository());

const _kDefaultCategories = [
  (name: 'Food',          color: Color(0xFFEF5350), icon: '🍔'),
  (name: 'Transport',     color: Color(0xFF42A5F5), icon: '🚗'),
  (name: 'Shopping',      color: Color(0xFFAB47BC), icon: '🛍️'),
  (name: 'Entertainment', color: Color(0xFFFF7043), icon: '🎬'),
  (name: 'Health',        color: Color(0xFF26A69A), icon: '💊'),
  (name: 'Bills',         color: Color(0xFF78909C), icon: '🧾'),
  (name: 'Others',        color: Color(0xFFBDBDBD), icon: '📦'),
];

class BudgetNotifier extends Notifier<List<Category>> {
  late final CategoryRepository _repo;

  @override
  List<Category> build() {
    _repo = ref.read(_categoryRepositoryProvider);
    final existing = _repo.getAll();
    if (existing.isNotEmpty) return existing;

    // Seed defaults on first run
    const uuid = Uuid();
    final defaults = _kDefaultCategories.map((d) => Category(
      id: uuid.v4(),
      name: d.name,
      colorValue: d.color.toARGB32(),
      icon: d.icon,
    )).toList();
    for (final c in defaults) {
      _repo.save(c);
    }
    return defaults;
  }

  Future<void> add(Category category) async {
    await _repo.save(category);
    state = [...state, category];
  }

  Future<void> update(Category category) async {
    await _repo.save(category);
    state = [
      for (final c in state)
        if (c.id == category.id) category else c,
    ];
  }

  Future<void> delete(String id) async {
    await _repo.delete(id);
    state = state.where((c) => c.id != id).toList();
  }
}

final budgetProvider =
    NotifierProvider<BudgetNotifier, List<Category>>(BudgetNotifier.new);
