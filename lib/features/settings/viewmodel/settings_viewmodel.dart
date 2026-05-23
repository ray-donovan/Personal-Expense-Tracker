import 'package:hive/hive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _kBoxName = 'userSettings';
const _kNameKey = 'userName';

class UserNameNotifier extends Notifier<String> {
  @override
  String build() {
    final box = Hive.box<String>(_kBoxName);
    return box.get(_kNameKey, defaultValue: 'Your Name')!;
  }

  Future<void> setName(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    await Hive.box<String>(_kBoxName).put(_kNameKey, trimmed);
    state = trimmed;
  }
}

final userNameProvider =
    NotifierProvider<UserNameNotifier, String>(UserNameNotifier.new);
