typedef OnMapValue<T> = T Function(Map<String, dynamic> json);

extension MapConverter on Map? {
  T? toEntityOrNull<T>({required OnMapValue<T> callback}) {
    if (this == null) return null;
    final json = Map<String, dynamic>.from(this!);
    return callback(json);
  }

  T toEntity<T>({required OnMapValue<T> callback}) {
    if (this == null) {
      throw Exception('Cannot convert null Map to entity');
    }
    final json = Map<String, dynamic>.from(this!);
    return callback(json);
  }
}

extension IterableMapConverter on Iterable<dynamic> {
  List<T> toEntityList<T>({required OnMapValue<T> callback}) {
    return map((dynamic e) {
      final json = Map<String, dynamic>.from(e as Map);
      return callback(json);
    }).toList();
  }

  List<T> toEntityListWhere<T>({
    required OnMapValue<T> callback,
    required bool Function(T) test,
  }) {
    return map((dynamic e) {
      final json = Map<String, dynamic>.from(e as Map);
      return callback(json);
    }).where(test).toList();
  }

  bool anyEntity<T>({
    required OnMapValue<T> callback,
    required bool Function(T) test,
  }) {
    return any((dynamic e) {
      final json = Map<String, dynamic>.from(e as Map);
      final entity = callback(json);
      return test(entity);
    });
  }
}
