import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:infrearnclass/common/component/pagination_listview.dart';
import 'package:infrearnclass/product/component/product_card.dart';
import 'package:infrearnclass/product/model/product_model.dart';
import 'package:infrearnclass/product/provider/product_provider.dart';
import 'package:infrearnclass/restaurant/view/restaurant_detail.dart';

class ProductScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return PaginationListView<ProductModel>(
      provider: productProvider,
      itembuilder: <ProductModel> (_, index, model) {
        return GestureDetector(
          onTap: (){
            context.goNamed(RestaurantDetailScreen.routeName, params: {
              'rid': model.restaurant.id,
            });
          },
          child: ProductCard.fromProductModel(
            model: model,
          ),
        );
      },
    );
  }
}
