import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resturent_billinng_app/core/models/restaurant_models.dart';
import 'package:resturent_billinng_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:resturent_billinng_app/features/home/presentation/pages/dine_in_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, this.onOpenMenu});

  final ValueChanged<OrderType>? onOpenMenu;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF6),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              const SliverToBoxAdapter(child: _HeroHeader()),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 18),
                sliver: SliverList.list(
                  children: [
                    _ActionCard(
                      title: 'Dine-In',
                      subtitle: 'Select table and\nstart billing',
                      icon: Icons.table_restaurant_rounded,
                      backgroundImage: 'assets/images/table.png',
                      color: const Color(0xFFF97316),
                      tint: const Color(0xFFFFF7ED),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const DineInPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    _ActionCard(
                      title: 'Billing / Parcel',
                      subtitle: 'Quick takeaway\ncounter order',
                      icon: Icons.shopping_bag_rounded,
                      backgroundImage: 'assets/images/billing.png',
                      color: const Color(0xFFE8232E),
                      tint: const Color(0xFFFFF1F2),
                      onTap: () => onOpenMenu?.call(OrderType.parcel),
                    ),
                    const SizedBox(height: 16),
                    _ActionCard(
                      title: 'Delivery',
                      subtitle: 'Capture customer\nphone & place order',
                      icon: Icons.delivery_dining_rounded,
                      backgroundImage: 'assets/images/map.png',
                      color: const Color(0xFF4C8F37),
                      tint: const Color(0xFFF0FDF4),
                      onTap: () => onOpenMenu?.call(OrderType.delivery),
                    ),
                    const SizedBox(height: 18),
                    _SummaryCard(state: state),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader();

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;
    final theme = Theme.of(context);

    return SizedBox(
      height: 226 + topPadding,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/home_hero_restaurant.png',
            fit: BoxFit.cover,
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFFFFFBF4),
                  Color(0xEFFFF7EE),
                  Color(0x22FFFFFF),
                ],
                stops: [0, 0.48, 1],
              ),
            ),
          ),

          Positioned(
            left: 24,
            right: 24,
            bottom: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good Morning 👋',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: const Color(0xFF74513D),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Restaurant Billing',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: const Color(0xFF2D1A10),
                    fontWeight: FontWeight.w900,
                    fontSize: 30,
                    height: 1.05,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Fast & easy billing for busy hours',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF76695F),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 34,
              decoration: const BoxDecoration(
                color: Color(0xFFFFFBF6),
                borderRadius: BorderRadius.vertical(top: Radius.circular(100)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.backgroundImage,
    required this.color,
    required this.tint,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String backgroundImage;
  final Color color;
  final Color tint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Ink(
          height: 120,
          decoration: BoxDecoration(
            color: tint,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withValues(alpha: 0.12)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
            image: DecorationImage(
              image: AssetImage(backgroundImage),
              alignment: Alignment.centerRight,
              fit: BoxFit.contain,
              opacity: 0.18,
              colorFilter: ColorFilter.mode(
                color.withValues(alpha: 0.28),
                BlendMode.srcATop,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 16, 16),
            child: Row(
              children: [
                Container(
                  width: 86,
                  height: 86,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: color.withValues(alpha: 0.28)),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.12),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: color, size: 48),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: const Color(0xFF221A16),
                          fontWeight: FontWeight.w900,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF746B65),
                          height: 1.35,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.35),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.state});

  final HomeState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFF0E7DF)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEEE1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.insert_chart_outlined_rounded,
                  color: Color(0xFFF97316),
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "Today's Summary",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF241D19),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _SummaryMetric(
                  label: 'Total Sales',
                  value: '₹${state.todaySalesTotal.toStringAsFixed(0)}',
                  color: const Color(0xFF26A65B),
                  icon: Icons.trending_up_rounded,
                ),
              ),
              const _SummaryDivider(),
              Expanded(
                child: _SummaryMetric(
                  label: 'Bills',
                  value: state.todayOrderCount.toString(),
                  color: const Color(0xFF5B6BFF),
                  icon: Icons.receipt_long_rounded,
                ),
              ),
              const _SummaryDivider(),
              Expanded(
                child: _SummaryMetric(
                  label: 'Orders',
                  value: state.todayOrderCount.toString(),
                  color: const Color(0xFF9C55E8),
                  icon: Icons.shopping_bag_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.schedule_rounded,
                size: 15,
                color: Color(0xFF9B938C),
              ),
              const SizedBox(width: 6),
              Text(
                'Last updated: ${_lastUpdatedLabel(state.lastUpdatedAt)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF8D8580),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                'View Details',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: const Color(0xFFF97316),
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: Color(0xFFF97316),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _lastUpdatedLabel(DateTime? dateTime) {
    if (dateTime == null) return '--';
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String label;
  final String value;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: const Color(0xFF8E8580),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            color: value.startsWith('₹') ? color : const Color(0xFF18181B),
            fontWeight: FontWeight.w900,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 15, color: color),
        ),
      ],
    );
  }
}

class _SummaryDivider extends StatelessWidget {
  const _SummaryDivider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 68, color: const Color(0xFFF0E7DF));
  }
}
