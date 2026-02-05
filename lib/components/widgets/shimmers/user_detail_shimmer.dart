import 'package:flutter/material.dart';
import 'shimmer_loading.dart';

class UserDetailShimmer extends StatelessWidget {
  const UserDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const ShimmerLoading(
            width: 120,
            height: 120,
            borderRadius: BorderRadius.all(Radius.circular(60)),
          ),
          const SizedBox(height: 24),
          ShimmerLoading(
            width: MediaQuery.of(context).size.width * 0.6,
            height: 28,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 8),
          ShimmerLoading(
            width: MediaQuery.of(context).size.width * 0.5,
            height: 20,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 32),
          ...List.generate(
            3,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerLoading(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 20,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(height: 8),
                      ShimmerLoading(
                        width: double.infinity,
                        height: 16,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
