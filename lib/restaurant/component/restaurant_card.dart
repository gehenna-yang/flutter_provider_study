import 'package:flutter/material.dart';
import 'package:infrearnclass/common/const/colors.dart';
import 'package:infrearnclass/restaurant/model/restaurant_detail_model.dart';
import 'package:infrearnclass/restaurant/model/restaurant_model.dart';

class RestaurantCard extends StatelessWidget {

  final Widget image;
  final String name;
  final List<String> tags;
  final int ratingsCount;
  final int deliveryTime;
  final int deliveryFee;
  final double ratings;
  final bool isDetail;
  final String? detail;

  const RestaurantCard({
    required this.image,
    required this.name,
    required this.tags,
    required this.ratingsCount,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.ratings,
    this.isDetail = false,
    this.detail,
    Key? key,
  }) : super(key: key);

  factory RestaurantCard.fromModel({
    required RestaurantModel model,
    bool isDetail = false,
  }) {
    return RestaurantCard(
      image: Image.network(model.thumbUrl, fit: BoxFit.cover,),
      name: model.name,
      tags: List<String>.from(model.tags),
      ratingsCount: model.ratingsCount,
      deliveryTime: model.deliveryTime,
      deliveryFee: model.deliveryFee,
      ratings: model.ratings,
      isDetail: isDetail,
      detail: model is RestaurantDetailModel ? model.detail: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isDetail ?
          image:
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: image,
          ),
        const SizedBox(height: 16,),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isDetail ? 16 : 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),),
              const SizedBox(height: 8,),
              Text(tags.join(' · '), style: TextStyle(fontSize: 14, color: BODY_TEXT_COLOR),),
              const SizedBox(height: 8,),
              Row(
                children: [
                  _IconText(icon: Icons.star, label: ratings.toString()),
                  renderDot(),
                  _IconText(icon: Icons.receipt, label: ratingsCount.toString()),
                  renderDot(),
                  _IconText(icon: Icons.timelapse_outlined, label: '${deliveryTime} 분'),
                  renderDot(),
                  _IconText(icon: Icons.monetization_on, label: deliveryFee == 0 ? '무료':deliveryFee.toString()),
                ],
              ),
              if(detail != null && isDetail)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(detail!)
                ),
            ],
          ),
        ),
      ],
    );
  }

  renderDot(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text('·', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),),
    );
  }
}

class _IconText extends StatelessWidget {
  final IconData icon;
  final String label;
  const _IconText({
    required this.icon,
    required this.label,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: PRIMARY_COLOR, size: 14,),
        const SizedBox(width: 8,),
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),),
      ],
    );
  }
}

