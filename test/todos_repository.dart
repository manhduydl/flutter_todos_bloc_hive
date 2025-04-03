import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_todos_bloc_hive/repository/todos_repository.dart';
import 'package:flutter_todos_bloc_hive/services/todos_api.dart';
import 'package:mocktail/mocktail.dart';

class MockTodosApi extends Mock implements TodosApi {}

void main() {
  group('TodosRepository', () {
    late TodosApi api;

    setUpAll(() {});

    setUp(() {
      api = MockTodosApi();
      when(() => api.getTodos()).thenAnswer((_) => Future(() => []));
    });

    TodosRepository createSubject() => TodosRepository(todosApi: api);

    group('constructor', () {
      test('works properly', () {
        expect(
          createSubject,
          returnsNormally,
        );
      });
    });

    group('getTodos', () {
      test('makes correct api request', () {
        final subject = createSubject();

        expect(
          subject.getTodos(),
          isA<Future>(),
        );

        verify(() => api.getTodos()).called(1);
      });
    });
  });
}
