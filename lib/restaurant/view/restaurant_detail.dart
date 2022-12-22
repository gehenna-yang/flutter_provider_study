import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:infrearnclass/common/const/data.dart';
import 'package:infrearnclass/common/layout/default_layout.dart';
import 'package:infrearnclass/product/component/product_card.dart';
import 'package:infrearnclass/restaurant/component/restaurant_card.dart';
import 'package:infrearnclass/restaurant/model/restaurant_detail_model.dart';

class Restaurant_Detail_Screen extends StatelessWidget {
  final String id;

  const Restaurant_Detail_Screen({
    required this.id,
    Key? key
  }) : super(key: key);

  Future<Map<String, dynamic>> getRestaurantDetail() async{
    final dio = Dio();

    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final resp = await dio.get(
      'http://$ip/restaurant/$id',
      options: Options(
          headers: {
            'authorization':'Bearer $accessToken',
          }
      ),
    );

    print(resp);

    return resp.data;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      titletxt: '불타는 떡볶이',
      child: FutureBuilder<Map<String, dynamic>>(
        future: getRestaurantDetail(),
        builder: (_, AsyncSnapshot<Map<String, dynamic>>snapshot) {
          if(!snapshot.hasData){
            return const Center(child: CircularProgressIndicator(),);
          }

          final item = RestaurantDetailModel.fromJson(json: snapshot.data!);

          return CustomScrollView(
            slivers: [
              renderTop(model: item),
              renderLabel(),
              renderProduct(),
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

  renderProduct() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: ProductCard()
            );
          },
          childCount: 10,
        ),
      ),
    );
  }


}
