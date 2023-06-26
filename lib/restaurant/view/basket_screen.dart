import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infrearnclass/common/const/colors.dart';
import 'package:infrearnclass/common/layout/default_layout.dart';
import 'package:infrearnclass/product/component/product_card.dart';
import 'package:infrearnclass/user/provider/basket_provider.dart';

class BasketScreen extends ConsumerWidget {
  static String get routeName => 'basket';

  const BasketScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basket = ref.watch(basketProvider);

    return DefaultLayout(
      titletxt: '장바구니',
      child: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (_, index) {
                    return const Divider(height: 32,);
                  },
                  itemCount: basket.length,
                  itemBuilder: (_, index) {
                    final model = basket[index];
                    return ProductCard.fromProductModel(
                      model: model.product,
                      onAdd: () {
                        ref.read(basketProvider.notifier).addToBasket(product: model.product);
                      },
                      onSubtract: () {
                        ref.read(basketProvider.notifier).removeFromBasket(product: model.product);
                      },
                    );
                  }
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('장바구니 금액', style: TextStyle(color: BODY_TEXT_COLOR),),
                      Text('₩${basket.fold<int>(0, (p, n) => p+(n.product.price*n.count))}'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('배달비', style: TextStyle(color: BODY_TEXT_COLOR),),
                      Text('₩${basket.fold<int>(0, (p, n) => p+(n.product.price*n.count))}'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('총액', style: TextStyle(fontWeight: FontWeight.w500),),
                      Text('₩${basket.fold<int>(0, (p, n) => p+(n.product.price*n.count))}'),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(primary: PRIMARY_COLOR),
                      child: const Text('결제하기')
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
