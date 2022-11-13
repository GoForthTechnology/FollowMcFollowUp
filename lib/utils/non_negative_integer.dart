import 'package:flutter/cupertino.dart';

class NonNegativeInteger extends ChangeNotifier {
  int _value;

  NonNegativeInteger(int initialValue) : _value = initialValue;

  int get() {
    return _value;
  }

  void set(int value) {
    _value = value;
    notifyListeners();
  }

  void increment() {
    _value++;
    notifyListeners();
  }

  void decrement() {
    if (_value <= 0) {
      throw Exception();
    }
    _value--;
    notifyListeners();
  }
}