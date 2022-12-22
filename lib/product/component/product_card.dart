import 'package:flutter/material.dart';
import 'package:infrearnclass/common/const/colors.dart';
import 'package:infrearnclass/restaurant/model/restaurant_detail_model.dart';

class ProductCard extends StatelessWidget {
  final Image image;
  final String name;
  final String detail;
  final int price;

  const ProductCard({
    required this.image,
    required this.name,
    required this.detail,
    required this.price,
    Key? key
  }) : super(key: key);

  factory ProductCard.fromModel({
    required RestaurantProductModel model,
  }) {
    return ProductCard(
      image: Image.network(model.imgUrl, width: 110, height: 110, fit: BoxFit.cover,),
      name: model.name,
      detail: model.detail,
      price: model.price,
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: image
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                Text(detail, maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, color: BODY_TEXT_COLOR),),
                Text('$price원', textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 12, color: PRIMARY_COLOR, fontWeight: FontWeight.w500),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
