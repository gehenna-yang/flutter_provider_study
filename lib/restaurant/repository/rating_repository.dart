
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infrearnclass/common/const/data.dart';
import 'package:infrearnclass/common/dio/dio.dart';
import 'package:infrearnclass/common/model/cusor_pagination_model.dart';
import 'package:infrearnclass/common/model/pagination_params.dart';
import 'package:infrearnclass/common/repository/base_pagination_repository.dart';
import 'package:infrearnclass/rating/model/rating_model.dart';
import 'package:retrofit/retrofit.dart';

part 'rating_repository.g.dart';

final ratingRepositoryProvider = Provider.family<RatingRepository, String>((ref, id) {
  return RatingRepository(ref.watch(dioProvider), baseUrl: 'http://$ip/restaurant/$id/rating');
});

@RestApi()
abstract class RatingRepository implements IBasePaginationRepository<RatingModel> {
  factory RatingRepository(Dio dio, {String baseUrl}) = _RatingRepository;

  @GET('/')
  @Headers({
    'accessToken': 'true',
  })
  Future<CursorPagination<RatingModel>> paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });
}