import 'package:flutter/material.dart';

import 'app_shimmer.dart';

class ContactListShimmer extends StatelessWidget {
  const ContactListShimmer({super.key, this.itemCount = 8});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Column(
        children: List.generate(itemCount, (index) {
          final isFirst = index == 0;
          final isLast = index == itemCount - 1;

          return DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: isFirst ? const Radius.circular(18) : Radius.zero,
                bottom: isLast ? const Radius.circular(18) : Radius.zero,
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 20,
                  ),
                  child: Row(
                    children: const [
                      ShimmerBox(width: 54, height: 54, borderRadius: 27),
                      SizedBox(width: 10),
                      Expanded(child: _ContactTextShimmer()),
                    ],
                  ),
                ),
                if (!isLast)
                  const Divider(
                    height: 1,
                    indent: 92,
                    color: Color(0xFFF0F0F0),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _ContactTextShimmer extends StatelessWidget {
  const _ContactTextShimmer();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerBox(width: (width * 0.38).clamp(120, 170), height: 16),
        const SizedBox(height: 5),
        ShimmerBox(width: (width * 0.28).clamp(95, 130), height: 15),
      ],
    );
  }
}
