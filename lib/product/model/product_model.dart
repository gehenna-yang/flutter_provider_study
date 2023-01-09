import 'package:infrearnclass/common/model/model_with_id.dart';
import 'package:infrearnclass/common/utils/data_utils.dart';
import 'package:infrearnclass/restaurant/model/restaurant_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel implements IModelWithId {
  final String id; // 상품 ID
  final String name; // 상품이름
  final String detail; // 상품정보
  @JsonKey(
    fromJson: DataUtils.pathToUrl,
  )
  final String imgUrl; // 이미지 URL
  final int price; // 상품 가격
  final RestaurantModel restaurant; // 레스토랑 정보

  ProductModel({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.detail,
    required this.price,
    required this.restaurant,
  });

  factory ProductModel.fromJson(Map<String, dynamic>json) => _$ProductModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

}