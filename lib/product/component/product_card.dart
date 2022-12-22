import 'package:flutter/material.dart';
import 'package:infrearnclass/common/const/colors.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset('asset/img/food/ddeok_bok_gi.jpg', width: 110, height: 110, fit: BoxFit.cover,)
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('떡볶이', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                Text('전통 떡볶이의 정석!\n맛있습니다', maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, color: BODY_TEXT_COLOR),),
                Text('10000원', textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 12, color: PRIMARY_COLOR, fontWeight: FontWeight.w500),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
