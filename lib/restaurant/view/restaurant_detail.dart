import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:infrearnclass/common/const/data.dart';
import 'package:infrearnclass/common/dio/dio.dart';
import 'package:infrearnclass/common/layout/default_layout.dart';
import 'package:infrearnclass/product/component/product_card.dart';
import 'package:infrearnclass/restaurant/component/restaurant_card.dart';
import 'package:infrearnclass/restaurant/model/restaurant_detail_model.dart';
import 'package:infrearnclass/restaurant/repository/restaurant_repository.dart';

class Restaurant_Detail_Screen extends StatelessWidget {
  final String id;
  final String name;

  const Restaurant_Detail_Screen({
    required this.id,
    required this.name,
    Key? key
  }) : super(key: key);

  Future<RestaurantDetailModel> getRestaurantDetail() async{
    final dio = Dio();

    dio.interceptors.add(CustomInterceptor(storage: storage));

    final repository = RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant');

    return repository.getRestaurantDetail(id: id);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      titletxt: name,
      child: FutureBuilder<RestaurantDetailModel>(
        future: getRestaurantDetail(),
        builder: (_, AsyncSnapshot<RestaurantDetailModel>snapshot) {
          if(snapshot.hasError){
            return Center(child: Text(snapshot.error.toString()),);
          }

          if(!snapshot.hasData){
            return const Center(child: CircularProgressIndicator(),);
          }

          return CustomScrollView(
            slivers: [
              renderTop(model: snapshot.data!),
              renderLabel(),
              renderProduct(products: snapshot.data!.products),
            ],
          );
        },
      ),
    );
  }

  SliverToBoxAdapter renderTop({
    required RestaurantDetailModel model,
  }) {
    return SliverToBoxAdapter(
      child: RestaurantCard.fromModel(
        model: model,
        isDetail: true,
      ),
    );
  }

  SliverPadding renderLabel() {
    return const SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverToBoxAdapter(
        child: Text('메뉴', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
      ),
    );
  }

  renderProduct({
    required List<RestaurantProductModel> products
  }) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          childCount: products.length,
          (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ProductCard.fromModel(model: products[index]),
            );
          },
        ),
      ),
    );
  }


}
