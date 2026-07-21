import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resturent_billinng_app/core/models/restaurant_models.dart';
import 'package:resturent_billinng_app/features/home/presentation/bloc/home_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({required this.onStartOrder, super.key});

  final ValueChanged<OrderType> onStartOrder;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFF7ED), Color(0xFFFFFFFF), Color(0xFFFFE7D6)],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              return ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  Text(
                    'Restaurant Billing',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF2E1608),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Fast counter billing for rush hours',
                    style: TextStyle(color: Color(0xFF70411F), fontSize: 14),
                  ),
                  const SizedBox(height: 28),
                  _ActionCard(
                    title: 'Dine-In',
                    subtitle: 'Select table and start bill',
                    icon: Icons.table_restaurant,
                    color: const Color(0xFFE85D04),
                    onTap: () => onStartOrder(OrderType.dineIn),
                  ),
                  const SizedBox(height: 14),
                  _ActionCard(
                    title: 'Billing / Parcel',
                    subtitle: 'Quick takeaway counter order',
                    icon: Icons.shopping_bag,
                    color: const Color(0xFFC1121F),
                    onTap: () => onStartOrder(OrderType.parcel),
                  ),
                  const SizedBox(height: 14),
                  _ActionCard(
                    title: 'Delivery',
                    subtitle: 'Capture customer phone',
                    icon: Icons.delivery_dining,
                    color: const Color(0xFF386641),
                    onTap: () => onStartOrder(OrderType.delivery),
                  ),
                  const SizedBox(height: 28),
                  _SummaryStrip(state: state),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 46, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(color: Color(0xFF6D6258)),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, size: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryStrip extends StatelessWidget {
  const _SummaryStrip({required this.state});

  final HomeState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2E1608),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SummaryValue(
              label: 'Today Sales',
              value: 'Rs ${state.todaySalesTotal.toStringAsFixed(0)}',
            ),
          ),
          Container(width: 1, height: 42, color: Colors.white24),
          Expanded(
            child: _SummaryValue(
              label: 'Bills',
              value: state.todayOrderCount.toString(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryValue extends StatelessWidget {
  const _SummaryValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Color(0xFFFFD7B5))),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}
