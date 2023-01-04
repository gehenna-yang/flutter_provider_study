

import 'package:infrearnclass/common/const/data.dart';
import 'package:infrearnclass/common/model/model_with_id.dart';
import 'package:infrearnclass/common/utils/data_utils.dart';
import 'package:infrearnclass/restaurant/model/restaurant_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'restaurant_detail_model.g.dart';

@JsonSerializable()
class RestaurantDetailModel extends RestaurantModel{
  RestaurantDetailModel({
    required super.id,
    required super.name,
    required super.thumbUrl,
    required super.tags,
    required super.priceRange,
    required super.ratings,
    required super.ratingsCount,
    required super.deliveryTime,
    required super.deliveryFee,
    required this.detail,
    required this.products,
  });
  final String detail;
  final List<RestaurantProductModel> products;

  factory RestaurantDetailModel.fromJson(Map<String, dynamic>json) => _$RestaurantDetailModelFromJson(json);
  Map<String, dynamic> toJson() => _$RestaurantDetailModelToJson(this);

}

@JsonSerializable()
class RestaurantProductModel implements IModelWithId{
  RestaurantProductModel({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.detail,
    required this.price,
  });
  final String id;
  final String name;
  @JsonKey(
    fromJson: DataUtils.pathToUrl,
  )
  final String imgUrl;
  final String detail;
  final int price;

  factory RestaurantProductModel.fromJson(Map<String, dynamic>json) => _$RestaurantProductModelFromJson(json);
  Map<String, dynamic> toJson() => _$RestaurantProductModelToJson(this);

}