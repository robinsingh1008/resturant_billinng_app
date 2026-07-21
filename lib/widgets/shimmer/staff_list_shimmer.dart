import 'package:flutter/material.dart';

import 'app_shimmer.dart';

class StaffListShimmer extends StatelessWidget {
  const StaffListShimmer({
    super.key,
    this.itemCount = 8,
    this.padding = const EdgeInsets.fromLTRB(12, 4, 12, 96),
    this.showSearchGap = false,
  });

  final int itemCount;
  final EdgeInsetsGeometry padding;
  final bool showSearchGap;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return AppShimmer(
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: padding,
        itemCount: itemCount + (showSearchGap ? 1 : 0),
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          if (showSearchGap && index == 0) {
            return const ShimmerBox(
              width: double.infinity,
              height: 48,
              borderRadius: 16,
            );
          }

          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const ShimmerBox(width: 52, height: 52, borderRadius: 26),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerBox(
                        width: (width * 0.42).clamp(130, 190),
                        height: 15,
                      ),
                      const SizedBox(height: 8),
                      ShimmerBox(
                        width: (width * 0.28).clamp(90, 135),
                        height: 13,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                const ShimmerBox(width: 58, height: 30, borderRadius: 15),
              ],
            ),
          );
        },
      ),
    );
  }
}
