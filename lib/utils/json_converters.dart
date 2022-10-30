import 'package:json_annotation/json_annotation.dart';
import 'package:time_machine/time_machine.dart';

class LocalDateConverter implements JsonConverter<LocalDate, int> {
  @override
  LocalDate fromJson(int json) {
    return LocalDate.fromEpochDay(json);
  }

  @override
  int toJson(LocalDate object) {
    return object.epochDay;
  }

}