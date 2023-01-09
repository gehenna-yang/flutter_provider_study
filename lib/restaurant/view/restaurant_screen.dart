
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infrearnclass/common/component/pagination_listview.dart';
import 'package:infrearnclass/restaurant/component/restaurant_card.dart';
import 'package:infrearnclass/restaurant/provider/restaurant_provider.dart';
import 'package:infrearnclass/restaurant/view/restaurant_detail.dart';

class RestaurantScreen extends ConsumerStatefulWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends ConsumerState<RestaurantScreen> {

  @override
  Widget build(BuildContext context) {
    return PaginationListView(
      provider: restaurantProvider,
      itembuilder: <RestaurantModel> (_, index, model) {
        return GestureDetector(
          child: RestaurantCard.fromModel(model: model),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => Restaurant_Detail_Screen(id: model.id, name: model.name,)));
          },
        );
      },
    );
  }
}