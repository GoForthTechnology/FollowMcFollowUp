
import 'package:flutter/cupertino.dart';

abstract class CrudInterface<T> extends ChangeNotifier {
  Stream<List<T>> getAll();

  Stream<T?> get(String id);

  Future<String> insert(T t);

  Future<void> update(T t);

  Future<void> remove(String id);
}

abstract class Indexable<T> {
  String? getId();
  T setId(String id);
}
