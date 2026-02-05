import 'package:flutter/material.dart';
import 'user_card_shimmer.dart';

class UserListShimmer extends StatelessWidget {
  final int itemCount;

  const UserListShimmer({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: itemCount,
      itemBuilder: (context, index) => const UserCardShimmer(),
    );
  }
}
