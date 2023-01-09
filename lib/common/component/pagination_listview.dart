
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infrearnclass/common/model/cusor_pagination_model.dart';
import 'package:infrearnclass/common/model/model_with_id.dart';
import 'package:infrearnclass/common/provider/pagination_provider.dart';
import 'package:infrearnclass/common/utils/pagination_utils.dart';
import 'package:infrearnclass/product/provider/product_provider.dart';

typedef PaginationWidgetBuilder<T extends IModelWithId> =
  Widget Function(BuildContext context, int index, T model);

class PaginationListView<T extends IModelWithId> extends ConsumerStatefulWidget {
  final StateNotifierProvider<PaginationProvider, CursorPaginationBase> provider;
  final PaginationWidgetBuilder<T> itembuilder;
  const PaginationListView({
    required this.provider,
    required this.itembuilder,
    Key? key
  }) : super(key: key);

  @override
  ConsumerState<PaginationListView> createState() => _PaginationListViewState<T>();
}

class _PaginationListViewState<T extends IModelWithId> extends ConsumerState<PaginationListView> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
  }

  void listener() {
    PaginationUtils.paginate(controller: controller, provider: ref.read(widget.provider.notifier));
  }

  @override
  void dispose() {
    controller.removeListener(listener);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.provider);

    // first loading
    if(state is CursorPaginationLoading){
      return const Center(child: CircularProgressIndicator(),);
    }

    // error
    if(state is CursorPaginationError) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(state.message, textAlign: TextAlign.center,),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: (){
              ref.read(widget.provider.notifier).paginate(forceRefetch: true);
            },
            child: Text('다시시도'),
          ),
        ],
      );
    }

    // CursorPagination
    // CursorPaginationFetchingMore
    // CursorPaginationRefetching

    final cp = state as CursorPagination<T>;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(
        controller: controller,
        itemCount: cp.data.length+1,
        separatorBuilder: (_, index) {
          return SizedBox(height: 16);
        },
        itemBuilder: (_, index) {
          if(index == cp.data.length){
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Center(
                child: cp is CursorPaginationFetchingMore ?
                CircularProgressIndicator() :
                Text('마지막 데이터입니다.'),
              ),
            );
          }

          final pitem = cp.data[index];

          return widget.itembuilder(
            context, index, pitem
          );
        },
      ),
    );
  }
}
