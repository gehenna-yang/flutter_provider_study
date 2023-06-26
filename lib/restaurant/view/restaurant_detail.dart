import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infrearnclass/common/const/colors.dart';
import 'package:infrearnclass/common/layout/default_layout.dart';
import 'package:infrearnclass/common/model/cusor_pagination_model.dart';
import 'package:infrearnclass/common/utils/pagination_utils.dart';
import 'package:infrearnclass/product/component/product_card.dart';
import 'package:infrearnclass/product/model/product_model.dart';
import 'package:infrearnclass/rating/component/rating_card.dart';
import 'package:infrearnclass/rating/model/rating_model.dart';
import 'package:infrearnclass/restaurant/component/restaurant_card.dart';
import 'package:infrearnclass/restaurant/model/restaurant_detail_model.dart';
import 'package:infrearnclass/restaurant/model/restaurant_model.dart';
import 'package:infrearnclass/restaurant/provider/restaurant_provider.dart';
import 'package:infrearnclass/restaurant/provider/restaurant_rating_provider.dart';
import 'package:infrearnclass/restaurant/view/basket_screen.dart';
import 'package:infrearnclass/user/provider/basket_provider.dart';
import 'package:skeletons/skeletons.dart';

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  static String get routeName => 'restaurantdetail';

  final String id;

  const RestaurantDetailScreen({
    required this.id,
    Key? key
  }) : super(key: key);

  @override
  ConsumerState<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends ConsumerState<RestaurantDetailScreen> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    ref.read(restaurantProvider.notifier).getDetail(id: widget.id);

    controller.addListener(listener);
  }

  void listener(){
    PaginationUtils.paginate(controller: controller, provider: ref.read(restaurantRatingProvider(widget.id).notifier,),);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantDetailProvider(widget.id));
    final ratingState = ref.watch(restaurantRatingProvider(widget.id));
    final basket = ref.watch(basketProvider);

    if(state == null) {
      return const DefaultLayout(child: Center(child: CircularProgressIndicator(),));
    }

    return DefaultLayout(
      floatingActionButton: FloatingActionButton(
        backgroundColor: PRIMARY_COLOR,
        onPressed: (){
          context.pushNamed(BasketScreen.routeName);
        },
        child: Badge(
          showBadge: basket.isNotEmpty,
          badgeContent: Text(basket.fold<int>(0, (previous, next) => previous + next.count).toString(),
            style: const TextStyle(color: PRIMARY_COLOR, fontSize: 10),),
          badgeStyle: const BadgeStyle(badgeColor: Colors.white),
          child: const Icon(
            Icons.shopping_basket_outlined
          ),
        ),
      ),
      child: CustomScrollView(
        controller: controller,
        slivers: [
          renderTop(model: state),
          if(state is! RestaurantDetailModel)
            renderLoading(),
          if(state is RestaurantDetailModel)
            renderLabel(),
          if(state is RestaurantDetailModel)
            renderProduct(products: state.products, restaurant: state),
          if(ratingState is CursorPagination<RatingModel>)
            renderRatings(models: ratingState.data),
        ],
      )
    );
  }

  SliverPadding renderRatings({
    required List<RatingModel> models,
  }){
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, index) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: RatingCard.fromModel(model: models[index]),
          ),
          childCount: models.length,
        ),
      ),
    );
  }

  SliverPadding renderLoading() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          List.generate(3, (index) => Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: SkeletonParagraph(
              style: const SkeletonParagraphStyle(
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
    required RestaurantModel restaurant,
    required List<RestaurantProductModel> products
  }) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          childCount: products.length,
          (context, index) {
            return InkWell(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: ProductCard.fromRestaurantProductModel(model: products[index]),
              ),
              onTap: () {
                ref.read(basketProvider.notifier).addToBasket(product:
                  ProductModel(
                    id: products[index].id,
                    name: products[index].name,
                    imgUrl: products[index].imgUrl,
                    detail: products[index].detail,
                    price: products[index].price,
                    restaurant: restaurant,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

}
