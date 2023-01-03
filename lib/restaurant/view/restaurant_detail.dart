import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infrearnclass/common/const/data.dart';
import 'package:infrearnclass/common/dio/dio.dart';
import 'package:infrearnclass/common/layout/default_layout.dart';
import 'package:infrearnclass/product/component/product_card.dart';
import 'package:infrearnclass/restaurant/component/restaurant_card.dart';
import 'package:infrearnclass/restaurant/model/restaurant_detail_model.dart';
import 'package:infrearnclass/restaurant/model/restaurant_model.dart';
import 'package:infrearnclass/restaurant/provider/restaurant_provider.dart';
import 'package:infrearnclass/restaurant/repository/restaurant_repository.dart';
import 'package:skeletons/skeletons.dart';

class Restaurant_Detail_Screen extends ConsumerStatefulWidget {
  final String id;
  final String name;

  const Restaurant_Detail_Screen({
    required this.id,
    required this.name,
    Key? key
  }) : super(key: key);

  @override
  ConsumerState<Restaurant_Detail_Screen> createState() => _Restaurant_Detail_ScreenState();
}

class _Restaurant_Detail_ScreenState extends ConsumerState<Restaurant_Detail_Screen> {

  @override
  void initState() {
    super.initState();
    ref.read(restaurantProvider.notifier).getDetail(id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantDetailProvider(widget.id));

    if(state == null) {
      return DefaultLayout(child: Center(child: CircularProgressIndicator(),));
    }

    return DefaultLayout(
      titletxt: widget.name,
      child: CustomScrollView(
        slivers: [
          renderTop(model: state),
          if(state is! RestaurantDetailModel)
            renderLoading(),
          if(state is RestaurantDetailModel)
            renderLabel(),
          if(state is RestaurantDetailModel)
            renderProduct(products: state.products),
        ],
      )
    );
  }

  SliverPadding renderLoading() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          List.generate(3, (index) => Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: SkeletonParagraph(
              style: SkeletonParagraphStyle(
                lines: 5,
                padding: EdgeInsets.zero
              ),
            ),
          )),
        ),
      ),
    );
  }

  SliverToBoxAdapter renderTop({
    required RestaurantModel model,
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
