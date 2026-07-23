import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resturent_billinng_app/app/app_theme.dart';
import 'package:resturent_billinng_app/core/constants/app_colors.dart';
import 'package:resturent_billinng_app/core/models/restaurant_models.dart';
import 'package:resturent_billinng_app/features/orders/presentation/bloc/orders_bloc.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _HistoryView();
  }
}

class _HistoryView extends StatelessWidget {
  const _HistoryView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, state) {
        final bills = state.bills.reversed.toList(growable: false);
        return Scaffold(
          backgroundColor: AppTheme.background,
          appBar: AppBar(
            backgroundColor: AppTheme.background,

            title: Text(
              'Orders History',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
            children: [
              const _HistoryDateFilters(),
              const SizedBox(height: 34),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${bills.length} Orders found',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.search_rounded,
                      size: 24,
                      color: Colors.black,
                    ),
                    label: Text(
                      'FILTER',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 44),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (bills.isEmpty)
                const _EmptyHistoryCard()
              else
                ...List.generate(bills.length, (index) {
                  final bill = bills[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index == bills.length - 1 ? 0 : 16,
                    ),
                    child: _HistoryOrderCard(
                      bill: bill,
                      invoiceNumber: bills.length - index,
                    ),
                  );
                }),
            ],
          ),
        );
      },
    );
  }
}

class _HistoryDateFilters extends StatelessWidget {
  const _HistoryDateFilters();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _DateFilterChip(
            label: 'Today',
            selected: true,
            textStyle: theme.textTheme.labelLarge,
          ),
          const SizedBox(width: 14),
          _DateFilterChip(
            label: 'Yesterday',
            textStyle: theme.textTheme.labelLarge,
          ),
          const SizedBox(width: 14),
          SizedBox(
            width: 246,
            child: _DateFilterChip(
              label: 'Select date range',
              icon: Icons.calendar_month_rounded,
              trailingIcon: Icons.keyboard_arrow_down_rounded,
              textStyle: theme.textTheme.labelLarge,
            ),
          ),
        ],
      ),
    );
  }
}

class _DateFilterChip extends StatelessWidget {
  const _DateFilterChip({
    required this.label,
    required this.textStyle,
    this.selected = false,
    this.icon,
    this.trailingIcon,
  });

  final String label;
  final TextStyle? textStyle;
  final bool selected;
  final IconData? icon;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? Colors.white : Colors.black;
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20, color: foreground.withValues(alpha: 0.75)),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textStyle?.copyWith(
                color: foreground,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          if (trailingIcon != null) ...[
            const SizedBox(width: 8),
            Icon(
              trailingIcon,
              size: 20,
              color: foreground.withValues(alpha: 0.8),
            ),
          ],
        ],
      ),
    );
  }
}

class _HistoryOrderCard extends StatelessWidget {
  const _HistoryOrderCard({required this.bill, required this.invoiceNumber});

  final Bill bill;
  final int invoiceNumber;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 20, 18, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppTheme.border),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  _invoiceId(bill, invoiceNumber),
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: AppTheme.text,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  _orderDateTime(bill.createdAt),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.text,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 36,
                height: 36,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  tooltip: 'Order options',
                  onPressed: () => _showOrderOptions(context),
                  icon: const Icon(Icons.more_vert_rounded, size: 28),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...bill.lines.map(
            (line) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _HistoryLineItem(line: line),
            ),
          ),
          const SizedBox(height: 8),
          const Divider(color: Color(0xFFECECEC), height: 28),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const _StatusPill(
                        label: 'PAID',
                        color: Color(0xFF2E7D32),
                      ),
                      const SizedBox(width: 10),
                      _StatusPill(label: _orderTypeLabel(bill.orderType)),
                      const SizedBox(width: 10),
                      _StatusPill(label: bill.paymentMode.label.toUpperCase()),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '₹${bill.total.toStringAsFixed(2)}',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showOrderOptions(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (sheetContext) {
        final theme = Theme.of(sheetContext);
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(36, 34, 36, 38),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order Options',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 26),
                _OrderOptionButton(
                  label: 'Edit Order',
                  onTap: () => Navigator.of(sheetContext).pop(),
                ),
                const SizedBox(height: 22),
                _OrderOptionButton(
                  label: 'Delete Order',
                  color: const Color(0xFFE53935),
                  onTap: () => Navigator.of(sheetContext).pop(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _invoiceId(Bill bill, int number) {
    final padded = number.toString().padLeft(4, '0');
    return 'ID: INV-${bill.createdAt.year}-$padded';
  }

  String _orderDateTime(DateTime dateTime) {
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '$hour:$minute $period | ${dateTime.day} ${months[dateTime.month - 1]}';
  }

  String _orderTypeLabel(OrderType orderType) {
    return switch (orderType) {
      OrderType.dineIn => 'BILLING',
      OrderType.parcel => 'BILLING',
      OrderType.delivery => 'DELIVERY',
    };
  }
}

class _HistoryLineItem extends StatelessWidget {
  const _HistoryLineItem({required this.line});

  final OrderLine line;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        _VegMark(isVeg: line.item.isVeg),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            line.item.name,
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppTheme.text,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(
          'x${line.quantity}',
          style: theme.textTheme.titleMedium?.copyWith(
            color: AppTheme.mutedText,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(width: 24),
        SizedBox(
          width: 58,
          child: Text(
            '₹${line.item.price.toStringAsFixed(0)}',
            textAlign: TextAlign.right,
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class _VegMark extends StatelessWidget {
  const _VegMark({required this.isVeg});

  final bool isVeg;

  @override
  Widget build(BuildContext context) {
    final color = isVeg ? const Color(0xFF137333) : const Color(0xFFC62828);
    return Container(
      width: 18,
      height: 18,
      alignment: Alignment.center,
      decoration: BoxDecoration(border: Border.all(color: color, width: 1.6)),
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, this.color = Colors.black});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _OrderOptionButton extends StatelessWidget {
  const _OrderOptionButton({
    required this.label,
    required this.onTap,
    this.color = const Color(0xFF424242),
  });

  final String label;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: double.infinity,
        height: 42,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyHistoryCard extends StatelessWidget {
  const _EmptyHistoryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 56, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppTheme.border),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        'No orders found',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: AppTheme.mutedText,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
