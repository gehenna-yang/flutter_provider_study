
import 'package:dio/dio.dart' hide Headers;
import 'package:infrearnclass/common/model/cusor_pagination_model.dart';
import 'package:infrearnclass/restaurant/model/restaurant_detail_model.dart';
import 'package:infrearnclass/restaurant/model/restaurant_model.dart';
import 'package:retrofit/retrofit.dart';

part 'restaurant_repository.g.dart';

@RestApi()
abstract class RestaurantRepository {
  factory RestaurantRepository(Dio dio, {String baseUrl})
   = _RestaurantRepository;

  // http://$ip/restaurant
  @GET('/')
  @Headers({
    'accessToken': 'true',
  })
  Future<CusorPagination<RestaurantModel>> paginate();

  // http://$ip/restaurant/:id
  @GET('/{id}')
  @Headers({
    'accessToken': 'true',
  })
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path('id') required String id,
  });
}