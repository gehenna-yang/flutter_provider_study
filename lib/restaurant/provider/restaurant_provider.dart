import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infrearnclass/common/model/cusor_pagination_model.dart';
import 'package:infrearnclass/common/model/pagination_params.dart';
import 'package:infrearnclass/common/provider/pagination_provider.dart';
import 'package:infrearnclass/restaurant/model/restaurant_model.dart';
import 'package:infrearnclass/restaurant/repository/restaurant_repository.dart';

final restaurantDetailProvider = Provider.family<RestaurantModel?, String>((ref, id) {
  final state = ref.watch(restaurantProvider);

  if(state is! CursorPagination){
    return null;
  }

  return state.data.firstWhere((element) => element.id == id);
});

final restaurantProvider = StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>(
  (ref) {
    final repository = ref.watch(restaurantRepositoryProvider);

    final notifier = RestaurantStateNotifier(repository: repository);

    return notifier;
  }
);

class RestaurantStateNotifier extends PaginationProvider<RestaurantModel, RestaurantRepository> {

  RestaurantStateNotifier({
    required super.repository,
  });

  void getDetail({
    required String id,
  }) async{
    // 만약 데이터가 없는 상태일 경우(CursorPagination이 아니라면)
    // 데이터를 가져오려 한다.
    if(state is! CursorPagination){
      await this.paginate();
    }

    // state != CursorPagination => return
    if(state is! CursorPagination){
      return;
    }

    final pstate = state as CursorPagination;

    final resp = await repository.getRestaurantDetail(id: id);

    // [RestaurantModel(1), RestaurantModel(2), RestaurantModel(3)]
    // id : 2인 친구를 Detail Model을 가져와라
    // getDetail(id: 2);
    // [RestaurantDetailModel(1), RestaurantDetailModel(2), RestaurantDetailModel(3)]
    state = pstate.copyWith(
        data: pstate.data.map<RestaurantModel>((e) => e.id == id ? resp : e).toList()
    );
  }
}