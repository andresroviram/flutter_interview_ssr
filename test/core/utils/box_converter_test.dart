import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_interview_ssr/core/utils/box_converter.dart';

class TestEntity {
  final String id;
  final String name;

  TestEntity(this.id, this.name);

  factory TestEntity.fromJson(Map<String, dynamic> json) {
    return TestEntity(json['id'] as String, json['name'] as String);
  }
}

void main() {
  group('MapConverter - toEntityOrNull', () {
    test('should convert Map to entity', () {
      final map = {'id': '1', 'name': 'Test'};
      final result = map.toEntityOrNull<TestEntity>(
        callback: (json) => TestEntity.fromJson(json),
      );

      expect(result, isNotNull);
      expect(result!.id, '1');
      expect(result.name, 'Test');
    });

    test('should return null when Map is null', () {
      const Map? map = null;
      final result = map.toEntityOrNull<TestEntity>(
        callback: (json) => TestEntity.fromJson(json),
      );

      expect(result, isNull);
    });

    test('should handle Map with dynamic type', () {
      final Map map = {'id': '2', 'name': 'Dynamic'};
      final result = map.toEntityOrNull<TestEntity>(
        callback: (json) => TestEntity.fromJson(json),
      );

      expect(result, isNotNull);
      expect(result!.id, '2');
      expect(result.name, 'Dynamic');
    });
  });

  group('MapConverter - toEntity', () {
    test('should convert Map to entity', () {
      final map = {'id': '1', 'name': 'Test'};
      final result = map.toEntity<TestEntity>(
        callback: (json) => TestEntity.fromJson(json),
      );

      expect(result.id, '1');
      expect(result.name, 'Test');
    });

    test('should throw exception when Map is null', () {
      const Map? map = null;
      expect(
        () => map.toEntity<TestEntity>(
          callback: (json) => TestEntity.fromJson(json),
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('exception should have descriptive message', () {
      const Map? map = null;
      try {
        map.toEntity<TestEntity>(callback: (json) => TestEntity.fromJson(json));
        fail('Should have thrown exception');
      } catch (e) {
        expect(e.toString(), contains('Cannot convert null Map to entity'));
      }
    });
  });

  group('IterableMapConverter - toEntityList', () {
    test('should convert Iterable of Maps to list of entities', () {
      final iterable = [
        {'id': '1', 'name': 'First'},
        {'id': '2', 'name': 'Second'},
        {'id': '3', 'name': 'Third'},
      ];

      final result = iterable.toEntityList<TestEntity>(
        callback: (json) => TestEntity.fromJson(json),
      );

      expect(result.length, 3);
      expect(result[0].id, '1');
      expect(result[0].name, 'First');
      expect(result[1].id, '2');
      expect(result[1].name, 'Second');
      expect(result[2].id, '3');
      expect(result[2].name, 'Third');
    });

    test('should handle empty Iterable', () {
      final iterable = <Map<String, dynamic>>[];
      final result = iterable.toEntityList<TestEntity>(
        callback: (json) => TestEntity.fromJson(json),
      );

      expect(result, isEmpty);
    });

    test('should handle Iterable with single item', () {
      final iterable = [
        {'id': '1', 'name': 'Only'},
      ];

      final result = iterable.toEntityList<TestEntity>(
        callback: (json) => TestEntity.fromJson(json),
      );

      expect(result.length, 1);
      expect(result[0].id, '1');
      expect(result[0].name, 'Only');
    });
  });

  group('IterableMapConverter - toEntityListWhere', () {
    test('should convert and filter entities', () {
      final iterable = [
        {'id': '1', 'name': 'First'},
        {'id': '2', 'name': 'Second'},
        {'id': '3', 'name': 'Third'},
      ];

      final result = iterable.toEntityListWhere<TestEntity>(
        callback: (json) => TestEntity.fromJson(json),
        test: (entity) => entity.id != '2',
      );

      expect(result.length, 2);
      expect(result[0].id, '1');
      expect(result[1].id, '3');
    });

    test('should return empty list when no entities match', () {
      final iterable = [
        {'id': '1', 'name': 'First'},
        {'id': '2', 'name': 'Second'},
      ];

      final result = iterable.toEntityListWhere<TestEntity>(
        callback: (json) => TestEntity.fromJson(json),
        test: (entity) => entity.id == '99',
      );

      expect(result, isEmpty);
    });

    test('should return all when all entities match', () {
      final iterable = [
        {'id': '1', 'name': 'First'},
        {'id': '2', 'name': 'Second'},
      ];

      final result = iterable.toEntityListWhere<TestEntity>(
        callback: (json) => TestEntity.fromJson(json),
        test: (entity) => entity.name.isNotEmpty,
      );

      expect(result.length, 2);
    });

    test('should filter based on complex condition', () {
      final iterable = [
        {'id': '1', 'name': 'First'},
        {'id': '2', 'name': 'Second'},
        {'id': '3', 'name': 'Third'},
        {'id': '4', 'name': 'Fourth'},
      ];

      final result = iterable.toEntityListWhere<TestEntity>(
        callback: (json) => TestEntity.fromJson(json),
        test: (entity) => entity.name.contains('i'),
      );

      expect(result.length, 2);
      expect(result[0].name, 'First');
      expect(result[1].name, 'Third');
    });
  });

  group('IterableMapConverter - anyEntity', () {
    test('should return true when any entity matches', () {
      final iterable = [
        {'id': '1', 'name': 'First'},
        {'id': '2', 'name': 'Second'},
        {'id': '3', 'name': 'Third'},
      ];

      final result = iterable.anyEntity<TestEntity>(
        callback: (json) => TestEntity.fromJson(json),
        test: (entity) => entity.id == '2',
      );

      expect(result, true);
    });

    test('should return false when no entity matches', () {
      final iterable = [
        {'id': '1', 'name': 'First'},
        {'id': '2', 'name': 'Second'},
      ];

      final result = iterable.anyEntity<TestEntity>(
        callback: (json) => TestEntity.fromJson(json),
        test: (entity) => entity.id == '99',
      );

      expect(result, false);
    });

    test('should return false for empty Iterable', () {
      final iterable = <Map<String, dynamic>>[];

      final result = iterable.anyEntity<TestEntity>(
        callback: (json) => TestEntity.fromJson(json),
        test: (entity) => true,
      );

      expect(result, false);
    });

    test('should check condition based on entity properties', () {
      final iterable = [
        {'id': '1', 'name': 'Short'},
        {'id': '2', 'name': 'VeryLongName'},
      ];

      final result = iterable.anyEntity<TestEntity>(
        callback: (json) => TestEntity.fromJson(json),
        test: (entity) => entity.name.length > 10,
      );

      expect(result, true);
    });

    test('should stop at first match', () {
      final iterable = [
        {'id': '1', 'name': 'First'},
        {'id': '2', 'name': 'Second'},
        {'id': '3', 'name': 'Third'},
      ];

      final result = iterable.anyEntity<TestEntity>(
        callback: (json) => TestEntity.fromJson(json),
        test: (entity) => entity.id == '1',
      );

      expect(result, true);
    });
  });
}
