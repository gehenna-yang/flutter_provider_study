import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infrearnclass/common/layout/default_layout.dart';

class BasketScreen extends ConsumerWidget {
  const BasketScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      child: Column(
        children: [],
      ),
    );
  }
}
