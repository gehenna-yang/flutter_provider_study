
import 'package:infrearnclass/restaurant/model/restaurant_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cusor_pagination_model.g.dart';

@JsonSerializable(
  genericArgumentFactories: true,
)
class CusorPagination<T>{
  final CusorPaginationMeta meta;
  final List<T> data;

  CusorPagination({
    required this.meta,
    required this.data,
  });

  factory CusorPagination.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) => _$CusorPaginationFromJson(json, fromJsonT);
  // Map<String, dynamic> toJson() => _$CusorPaginationToJson(this,);
}

@JsonSerializable()
class CusorPaginationMeta {
  final int count;
  final bool hasMore;

  CusorPaginationMeta({
    required this.count,
    required this.hasMore,
  });

  factory CusorPaginationMeta.fromJson(Map<String, dynamic>json) => _$CusorPaginationMetaFromJson(json);
  Map<String, dynamic> toJson() => _$CusorPaginationMetaToJson(this);
}