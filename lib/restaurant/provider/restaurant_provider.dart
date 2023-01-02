import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infrearnclass/common/model/cusor_pagination_model.dart';
import 'package:infrearnclass/common/model/pagination_params.dart';
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

class RestaurantStateNotifier extends StateNotifier<CursorPaginationBase> {
  final RestaurantRepository repository;

  RestaurantStateNotifier({
    required this.repository,
  }): super(CursorPaginationLoading()){
    paginate();
  }

  Future<void> paginate({
    int fetchCount = 20, // data count / default = 20
    bool fetchMore = false, // 추가 데이터 여부 true: fetch data list / false: first data list
    bool forceRefetch = false, // 강제 재로딩 true or false
  }) async{
    try {
      /**
       *   state의 상태
       *   1. CursorPagination - 정사적으로 데이터가 있는 상태
       *   2. CursorPaginationLoading - 데이터가 로딩중인 상태 (현재 non cache)
       *   3. CursorPaginationError - 에러가 있는 상태
       *   4. CursorPaginationRefetching - 첫번쨰 페이지부터 다시 데이터를 가져올때
       *   5. CursorPaginationFetchMore - 추가 데이터를 paginate 해오라는 요청을 받았을떄
       * */

      // hasMore == false (기존 상태에서 이미 다음 데이터가 없는 경우)
      // loading - fetchMore == true
      // loading - fetchMore == false (refresh)
      if(state is CursorPagination && !forceRefetch){
        final pstate = state as CursorPagination;

        if(!pstate.meta.hasMore){
          return;
        }
      }

      final isLoading = state is CursorPaginationLoading;
      final isRefetch = state is CursorPaginationRefetching;
      final isFetchMore = state is CursorPaginationFetchingMore;

      if(fetchMore && (isLoading || isRefetch || isFetchMore)){
        return;
      }

      // pagination params create
      PaginationParams paginationParams = PaginationParams(count: fetchCount);

      // fetchMore
      // data to add
      if(fetchMore){
        final pstate = state as CursorPagination;
        state = CursorPaginationFetchingMore(meta: pstate.meta, data: pstate.data);
        paginationParams = paginationParams.copyWith(after: pstate.data.last.id);
      } else {
        // get data
        // 기존 데이터가 있는 경우 보존한채로 fetch 진행
        if(state is CursorPagination && !forceRefetch) {
          final pstate = state as CursorPagination;
          state = CursorPaginationRefetching(meta: pstate.meta, data: pstate.data);
        } else {
          state = CursorPaginationLoading();
        }
      }

      final resp = await repository.paginate(paginationParams: paginationParams);

      if(state is CursorPaginationFetchingMore) {
        final pstate = state as CursorPaginationFetchingMore;

        // 기존 데이터에 신규 데이터 추가
        state = resp.copyWith(data: [
          ...pstate.data,
          ...resp.data,
        ]);
      } else {
        state = resp;
      }
    } catch (e) {
      state = CursorPaginationError(message: '데이터를 가져오지 못했습니다.');
    }
  }

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