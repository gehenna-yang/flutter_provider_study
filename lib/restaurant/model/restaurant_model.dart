import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infrearnclass/common/const/data.dart';

enum RestaurantPriceRange{
  expensive,
  medium,
  cheap,
}

class RestaurantModel {
  RestaurantModel({
    required this.id,
    required this.name,
    required this.thumbUrl,
    required this.tags,
    required this.priceRange,
    required this.ratings,
    required this.ratingsCount,
    required this.deliveryTime,
    required this.deliveryFee,
  });

  final String id;
  final String name;
  final String thumbUrl;
  final List<String> tags;
  final RestaurantPriceRange priceRange;
  final double ratings;
  final int ratingsCount;
  final int deliveryTime;
  final int deliveryFee;

  factory RestaurantModel.fromJson({
    required Map<String, dynamic> item,
  }) {
    return RestaurantModel(
        id: item['id'],
        name: item['name'],
        thumbUrl: 'http://$ip${item['thumbUrl']}',
        tags: List<String>.from(item['tags']),
        priceRange: RestaurantPriceRange.values.firstWhere(
              (e) => e.name == item['priceRange'],
        ),
        ratings: item['ratings'],
        ratingsCount: item['ratingsCount'],
        deliveryTime: item['deliveryTime'],
        deliveryFee: item['deliveryFee']
    );
  }
}