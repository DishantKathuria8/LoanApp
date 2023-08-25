import 'package:json_annotation/json_annotation.dart';

part 'questionnaire.g.dart';

@JsonSerializable()
class Questionnaire {
  final String title;
  final String name;
  final String slug;
  final String description;
  final Schema schema;

  Questionnaire({
    required this.title,
    required this.name,
    required this.slug,
    required this.description,
    required this.schema,
  });

  factory Questionnaire.fromJson(Map<String, dynamic> json) =>
      _$QuestionnaireFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionnaireToJson(this);
}

@JsonSerializable()
class Schema {
  final List<Field> fields;

  Schema({required this.fields});

  factory Schema.fromJson(Map<String, dynamic> json) => _$SchemaFromJson(json);

  Map<String, dynamic> toJson() => _$SchemaToJson(this);
}

@JsonSerializable()
class Field {
  final String type;
  final int version;
  final dynamic schema;

  Field({
    required this.type,
    required this.version,
    required this.schema,
  });

  factory Field.fromJson(Map<String, dynamic> json) => _$FieldFromJson(json);

  Map<String, dynamic> toJson() => _$FieldToJson(this);
}
