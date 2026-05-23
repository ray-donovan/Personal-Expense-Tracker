import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/category_model.dart';

class CategoriesNotifier extends Notifier<List<Category>> {
  @override
  List<Category> build() => [];

  void add(Category category) {
    state = [...state, category];
  }

  void update(Category category) {
    state = [
      for (final c in state)
        if (c.id == category.id) category else c,
    ];
  }

  void delete(String id) {
    state = state.where((c) => c.id != id).toList();
  }
}

final categoriesProvider =
    NotifierProvider<CategoriesNotifier, List<Category>>(
        CategoriesNotifier.new);
