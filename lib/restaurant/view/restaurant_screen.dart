import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:infrearnclass/common/const/data.dart';
import 'package:infrearnclass/restaurant/component/restaurant_card.dart';
import 'package:infrearnclass/restaurant/model/restaurant_model.dart';
import 'package:infrearnclass/restaurant/view/restaurant_detail.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  Future<List> paginateRestaurant() async{
    final dio = Dio();

    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final resp = await dio.get(
      'http://$ip/restaurant',
      options: Options(
        headers: {
          'authorization':'Bearer $accessToken',
        }
      ),
    );

    return resp.data['data'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FutureBuilder<List>(
            future: paginateRestaurant(),
            builder: (context, AsyncSnapshot<List> snapshot) {
              if(!snapshot.hasData){
                return Container();
              }

              print(snapshot.data);

              return ListView.separated(
                  itemCount: snapshot.data!.length,
                  separatorBuilder: (_, index) {
                    return SizedBox(height: 16);
                  },
                  itemBuilder: (_, index) {
                    final pitem = RestaurantModel.fromJson(item: snapshot.data![index]);

                    return GestureDetector(
                      child: RestaurantCard.fromModel(model: pitem),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => Restaurant_Detail_Screen(id: pitem.id,)));
                      },
                    );
                  },
              );
            },
          ),
        ),
      ),
    );
  }
}