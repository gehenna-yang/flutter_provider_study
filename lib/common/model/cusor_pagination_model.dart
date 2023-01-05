
import 'package:infrearnclass/restaurant/model/restaurant_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cusor_pagination_model.g.dart';

abstract class CursorPaginationBase {}

class CursorPaginationError extends CursorPaginationBase {
  final String message;

  CursorPaginationError({required this.message,});
}

class CursorPaginationLoading extends CursorPaginationBase {}

@JsonSerializable(
  genericArgumentFactories: true,
)
class CursorPagination<T> extends CursorPaginationBase {
  final CursorPaginationMeta meta;
  final List<T> data;

  CursorPagination({
    required this.meta,
    required this.data,
  });

  CursorPagination copyWith({
    CursorPaginationMeta? meta,
    List<T>? data,
  }) {
    return CursorPagination<T>(meta: meta?? this.meta, data: data?? this.data);
  }

  factory CursorPagination.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) => _$CursorPaginationFromJson(json, fromJsonT);
  // Map<String, dynamic> toJson() => _$CursorPaginationToJson(this,);
}

@JsonSerializable()
class CursorPaginationMeta {
  final int count;
  final bool hasMore;

  CursorPaginationMeta({
    required this.count,
    required this.hasMore,
  });

  CursorPaginationMeta copyWith ({
    int? count,
    bool? hasMore,
  }) {
    return CursorPaginationMeta(count: count?? this.count, hasMore: hasMore?? this.hasMore);
  }

  factory CursorPaginationMeta.fromJson(Map<String, dynamic>json) => _$CursorPaginationMetaFromJson(json);
  Map<String, dynamic> toJson() => _$CursorPaginationMetaToJson(this);
}

// refresh search
class CursorPaginationRefetching<T> extends CursorPagination<T> {
  CursorPaginationRefetching({
    required super.meta,
    required super.data,
  });
}

// list add data
class CursorPaginationFetchingMore<T> extends CursorPagination<T> {
  CursorPaginationFetchingMore({
    required super.meta,
    required super.data,
  });
}