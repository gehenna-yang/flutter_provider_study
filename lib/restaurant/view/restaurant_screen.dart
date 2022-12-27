import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:infrearnclass/common/const/data.dart';
import 'package:infrearnclass/common/dio/dio.dart';
import 'package:infrearnclass/restaurant/component/restaurant_card.dart';
import 'package:infrearnclass/restaurant/model/restaurant_model.dart';
import 'package:infrearnclass/restaurant/repository/restaurant_repository.dart';
import 'package:infrearnclass/restaurant/view/restaurant_detail.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  Future<List<RestaurantModel>> paginateRestaurant() async{
    final dio = Dio();

    dio.interceptors.add(CustomInterceptor(storage: storage));

    final response = await RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant').paginate();

    return response.data;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FutureBuilder<List<RestaurantModel>>(
            future: paginateRestaurant(),
            builder: (context, AsyncSnapshot<List<RestaurantModel>> snapshot) {
              if(!snapshot.hasData){
                return Container();
              }

              return ListView.separated(
                  itemCount: snapshot.data!.length,
                  separatorBuilder: (_, index) {
                    return SizedBox(height: 16);
                  },
                  itemBuilder: (_, index) {
                    final pitem = snapshot.data![index];

                    return GestureDetector(
                      child: RestaurantCard.fromModel(model: pitem),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => Restaurant_Detail_Screen(id: pitem.id, name: pitem.name,)));
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