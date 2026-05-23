import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:personal_expense_tracker/features/settings/viewmodel/settings_viewmodel.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_test_');
    Hive.init(tempDir.path);
    await Hive.openBox<String>('userSettings');
  });

  tearDown(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  ProviderContainer makeContainer() => ProviderContainer();

  group('UserNameNotifier', () {
    test('defaults to "Your Name" when box is empty', () {
      final container = makeContainer();
      addTearDown(container.dispose);

      expect(container.read(userNameProvider), 'Your Name');
    });

    test('setName updates state', () async {
      final container = makeContainer();
      addTearDown(container.dispose);

      await container.read(userNameProvider.notifier).setName('Jason Lee');

      expect(container.read(userNameProvider), 'Jason Lee');
    });

    test('setName trims whitespace', () async {
      final container = makeContainer();
      addTearDown(container.dispose);

      await container.read(userNameProvider.notifier).setName('  Jason  ');

      expect(container.read(userNameProvider), 'Jason');
    });

    test('setName persists to Hive box', () async {
      final container = makeContainer();
      addTearDown(container.dispose);

      await container.read(userNameProvider.notifier).setName('Jason Lee');

      final stored = Hive.box<String>('userSettings').get('userName');
      expect(stored, 'Jason Lee');
    });

    test('new container reads persisted name from box', () async {
      final container = makeContainer();
      await container.read(userNameProvider.notifier).setName('Jason Lee');
      container.dispose();

      final container2 = makeContainer();
      addTearDown(container2.dispose);

      expect(container2.read(userNameProvider), 'Jason Lee');
    });

    test('setName ignores empty or whitespace-only input', () async {
      final container = makeContainer();
      addTearDown(container.dispose);

      await container.read(userNameProvider.notifier).setName('Jason Lee');
      await container.read(userNameProvider.notifier).setName('');
      expect(container.read(userNameProvider), 'Jason Lee');

      await container.read(userNameProvider.notifier).setName('   ');
      expect(container.read(userNameProvider), 'Jason Lee');
    });
  });
}
