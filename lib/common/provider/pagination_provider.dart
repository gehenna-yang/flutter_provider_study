
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infrearnclass/common/model/cusor_pagination_model.dart';
import 'package:infrearnclass/common/model/model_with_id.dart';
import 'package:infrearnclass/common/model/pagination_params.dart';
import 'package:infrearnclass/common/repository/base_pagination_repository.dart';

class PaginationProvider<
T extends IModelWithId,
U extends IBasePaginationRepository<T>
> extends StateNotifier<CursorPaginationBase> {
  final U repository;

  PaginationProvider({
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
        final pstate = state as CursorPagination<T>;

        state = CursorPaginationFetchingMore(meta: pstate.meta, data: pstate.data);

        paginationParams = paginationParams.copyWith(after: pstate.data.last.id);
      } else {
        // get data
        // 기존 데이터가 있는 경우 보존한채로 fetch 진행
        if(state is CursorPagination && !forceRefetch) {
          final pstate = state as CursorPagination<T>;

          state = CursorPaginationRefetching<T>(meta: pstate.meta, data: pstate.data);
        } else {
          state = CursorPaginationLoading();
        }
      }

      final resp = await repository.paginate(paginationParams: paginationParams);

      if(state is CursorPaginationFetchingMore) {
        final pstate = state as CursorPaginationFetchingMore<T>;

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

}