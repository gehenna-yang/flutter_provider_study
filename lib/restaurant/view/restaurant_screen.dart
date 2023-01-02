import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infrearnclass/common/const/data.dart';
import 'package:infrearnclass/common/dio/dio.dart';
import 'package:infrearnclass/common/model/cusor_pagination_model.dart';
import 'package:infrearnclass/restaurant/component/restaurant_card.dart';
import 'package:infrearnclass/restaurant/model/restaurant_model.dart';
import 'package:infrearnclass/restaurant/provider/restaurant_provider.dart';
import 'package:infrearnclass/restaurant/repository/restaurant_repository.dart';
import 'package:infrearnclass/restaurant/view/restaurant_detail.dart';

class RestaurantScreen extends ConsumerWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(restaurantProvider);

    if(data.length == 0){
      return Center(child: CircularProgressIndicator(),);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(
        itemCount: data.length,
        separatorBuilder: (_, index) {
          return SizedBox(height: 16);
        },
        itemBuilder: (_, index) {
          final pitem = data[index];

          return GestureDetector(
            child: RestaurantCard.fromModel(model: pitem),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => Restaurant_Detail_Screen(id: pitem.id, name: pitem.name,)));
            },
          );
        },
      ),
    );
  }
}