import 'package:infrearnclass/common/model/cusor_pagination_model.dart';
import 'package:infrearnclass/common/model/model_with_id.dart';
import 'package:infrearnclass/common/model/pagination_params.dart';

abstract class IBasePaginationRepository<T extends IModelWithId>{

  Future<CursorPagination<T>> paginate({
    PaginationParams? paginationParams = const PaginationParams(),
  });

}