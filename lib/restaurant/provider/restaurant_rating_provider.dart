import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infrearnclass/common/model/cusor_pagination_model.dart';
import 'package:infrearnclass/common/provider/pagination_provider.dart';
import 'package:infrearnclass/rating/model/rating_model.dart';
import 'package:infrearnclass/restaurant/repository/rating_repository.dart';

final restaurantRatingProvider = StateNotifierProvider.family<RestaurantRatingStateNotifier, CursorPaginationBase, String>((ref, id) {
  final repo = ref.watch(ratingRepositoryProvider(id));
  return RestaurantRatingStateNotifier(repository: repo);
});

class RestaurantRatingStateNotifier extends PaginationProvider<RatingModel, RatingRepository> {

  RestaurantRatingStateNotifier({
    required super.repository
  });
}