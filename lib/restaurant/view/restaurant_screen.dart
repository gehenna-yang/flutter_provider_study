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

class RestaurantScreen extends ConsumerStatefulWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends ConsumerState<RestaurantScreen> {

  final ScrollController controller = ScrollController();


  @override
  void initState() {
    super.initState();

    controller.addListener(scrollListener);
  }

  void scrollListener() {
    if(controller.offset > controller.position.maxScrollExtent - 300){
      ref.read(restaurantProvider.notifier).paginate(fetchMore: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(restaurantProvider);

    // first loading
    if(data is CursorPaginationLoading){
      return const Center(child: CircularProgressIndicator(),);
    }

    // error
    if(data is CursorPaginationError) {
      return Center(child: Text(data.message),);
    }

    // CursorPagination
    // CursorPaginationFetchingMore
    // CursorPaginationRefetching

    final cp = data as CursorPagination;

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
                child: data is CursorPaginationFetchingMore ?
                  CircularProgressIndicator() :
                  Text('마지막 데이터입니다.'),
              ),
            );
          }

          final pitem = cp.data[index];

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