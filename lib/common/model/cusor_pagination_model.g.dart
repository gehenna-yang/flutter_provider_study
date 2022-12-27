// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cusor_pagination_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CusorPagination<T> _$CusorPaginationFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    CusorPagination<T>(
      meta: CusorPaginationMeta.fromJson(json['meta'] as Map<String, dynamic>),
      data: (json['data'] as List<dynamic>).map(fromJsonT).toList(),
    );

Map<String, dynamic> _$CusorPaginationToJson<T>(
  CusorPagination<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'meta': instance.meta,
      'data': instance.data.map(toJsonT).toList(),
    };

CusorPaginationMeta _$CusorPaginationMetaFromJson(Map<String, dynamic> json) =>
    CusorPaginationMeta(
      count: json['count'] as int,
      hasMore: json['hasMore'] as bool,
    );

Map<String, dynamic> _$CusorPaginationMetaToJson(
        CusorPaginationMeta instance) =>
    <String, dynamic>{
      'count': instance.count,
      'hasMore': instance.hasMore,
    };
