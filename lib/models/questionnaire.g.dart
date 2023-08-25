// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questionnaire.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Questionnaire _$QuestionnaireFromJson(Map<String, dynamic> json) =>
    Questionnaire(
      title: json['title'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String,
      schema: Schema.fromJson(json['schema'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$QuestionnaireToJson(Questionnaire instance) =>
    <String, dynamic>{
      'title': instance.title,
      'name': instance.name,
      'slug': instance.slug,
      'description': instance.description,
      'schema': instance.schema,
    };

Schema _$SchemaFromJson(Map<String, dynamic> json) => Schema(
      fields: (json['fields'] as List<dynamic>)
          .map((e) => Field.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SchemaToJson(Schema instance) => <String, dynamic>{
      'fields': instance.fields,
    };

Field _$FieldFromJson(Map<String, dynamic> json) => Field(
      type: json['type'] as String,
      version: json['version'] as int,
      schema: json['schema'],
    );

Map<String, dynamic> _$FieldToJson(Field instance) => <String, dynamic>{
      'type': instance.type,
      'version': instance.version,
      'schema': instance.schema,
    };
