import 'package:flutter/material.dart';
import 'address_card_shimmer.dart';

class AddressListShimmer extends StatelessWidget {
  final int itemCount;

  const AddressListShimmer({super.key, this.itemCount = 3});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: itemCount,
      itemBuilder: (context, index) => const AddressCardShimmer(),
    );
  }
}
