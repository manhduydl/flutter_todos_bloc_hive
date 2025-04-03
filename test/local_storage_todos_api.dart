import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_todos_bloc_hive/services/local_storage_todos_api.dart';

void main() {
  group('LocalStorageTodosApi', () {
    setUp(() {});

    LocalStorageTodosApi createSubject() {
      return LocalStorageTodosApi();
    }

    group('constructor', () {
      test('works properly', () {
        expect(
          createSubject,
          returnsNormally,
        );
      });
    });
  });
}
