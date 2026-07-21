import 'package:flutter/material.dart';

import 'app_shimmer.dart';

class CashBookShimmer extends StatelessWidget {
  const CashBookShimmer({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return AppShimmer(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const _CashBookGroupHeaderShimmer(),
          const SizedBox(height: 10),
          for (var index = 0; index < itemCount; index++) ...[
            _CashBookEntryRowShimmer(width: width, isFirst: index == 0),
            if (index != itemCount - 1)
              const Divider(height: 1, indent: 74, color: Color(0xFFF0F0F0)),
          ],
        ],
      ),
    );
  }
}

class _CashBookGroupHeaderShimmer extends StatelessWidget {
  const _CashBookGroupHeaderShimmer();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(width: (width * 0.42).clamp(130, 190), height: 16),
          const SizedBox(height: 14),
          const Row(
            children: [
              Expanded(child: ShimmerBox(width: double.infinity, height: 42)),
              SizedBox(width: 8),
              Expanded(child: ShimmerBox(width: double.infinity, height: 42)),
              SizedBox(width: 8),
              Expanded(child: ShimmerBox(width: double.infinity, height: 42)),
            ],
          ),
        ],
      ),
    );
  }
}

class _CashBookEntryRowShimmer extends StatelessWidget {
  const _CashBookEntryRowShimmer({required this.width, required this.isFirst});

  final double width;
  final bool isFirst;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(14, isFirst ? 14 : 12, 14, 12),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        children: [
          const ShimmerBox(width: 48, height: 48, borderRadius: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: (width * 0.38).clamp(120, 170), height: 14),
                const SizedBox(height: 8),
                ShimmerBox(width: (width * 0.24).clamp(82, 115), height: 12),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const ShimmerBox(width: 74, height: 18),
        ],
      ),
    );
  }
}
