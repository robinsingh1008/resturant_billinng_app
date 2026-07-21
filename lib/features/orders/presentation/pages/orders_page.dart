import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resturent_billinng_app/app/app_theme.dart';
import 'package:resturent_billinng_app/core/models/restaurant_models.dart';
import 'package:resturent_billinng_app/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:resturent_billinng_app/features/orders/presentation/widgets/receipt_preview.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  static const _categories = ['Starters', 'Main Course', 'Drinks', 'Desserts'];

  String _selectedCategory = 'Starters';

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrdersBloc, OrdersState>(
      listenWhen: (previous, current) =>
          previous.submittedBill != current.submittedBill &&
          current.submittedBill != null,
      listener: (context, state) {
        final bill = state.submittedBill;
        if (bill != null) _showBillDialog(context, bill);
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Billing Counter'),
            actions: [
              IconButton(
                tooltip: 'Refresh menu',
                onPressed: () {
                  context.read<OrdersBloc>().add(const OrdersStarted());
                },
                icon: const Icon(Icons.refresh),
              ),
              const SizedBox(width: 8),
            ],
            bottom: const TabBar(
              tabs: [
                Tab(text: 'New Bill'),
                Tab(text: 'History'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              BlocBuilder<OrdersBloc, OrdersState>(
                builder: (context, state) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth >= 920;
                      final menu = _filteredItems(state);
                      final menuSection = _MenuSection(
                        categories: _categories,
                        selectedCategory: _selectedCategory,
                        items: menu,
                        state: state,
                        onCategoryChanged: (category) {
                          setState(() => _selectedCategory = category);
                        },
                      );
                      final cartSection = _CartSection(state: state);

                      if (isWide) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 7, child: menuSection),
                              const SizedBox(width: 16),
                              SizedBox(width: 390, child: cartSection),
                            ],
                          ),
                        );
                      }

                      return ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          SizedBox(height: 620, child: menuSection),
                          const SizedBox(height: 16),
                          cartSection,
                        ],
                      );
                    },
                  );
                },
              ),
              const _HistoryView(),
            ],
          ),
        ),
      ),
    );
  }

  List<MenuItem> _filteredItems(OrdersState state) {
    return state.filteredItems
        .where((item) => item.category == _selectedCategory)
        .toList(growable: false);
  }

  void _showBillDialog(BuildContext context, Bill bill) {
    final text = _billText(bill);
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Bill generated'),
        content: SizedBox(
          width: 360,
          child: SingleChildScrollView(
            child: ReceiptPreview(
              lines: bill.lines,
              orderType: bill.orderType,
              paymentMode: bill.paymentMode,
              subtotal: bill.subtotal,
              gst: bill.gst,
              discount: bill.discount,
              total: bill.total,
              billId: bill.id,
              tableNumber: bill.tableNumber,
              customerName: bill.customerName,
              customerPhone: bill.customerPhone,
              createdAt: bill.createdAt,
            ),
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: text));
              Navigator.of(context).pop();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Receipt copied')));
            },
            icon: const Icon(Icons.copy),
            label: const Text('Copy'),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.print),
            label: const Text('Print'),
          ),
        ],
      ),
    );
  }

  String _billText(Bill bill) {
    final buffer = StringBuffer()
      ..writeln('RESTAURANT BILLING')
      ..writeln('${bill.orderType.label}  Bill #${bill.id.substring(0, 6)}');
    if (bill.tableNumber != null) buffer.writeln('Table: ${bill.tableNumber}');
    if (bill.customerPhone.isNotEmpty) {
      buffer.writeln('Customer: ${bill.customerName} ${bill.customerPhone}');
    }
    buffer.writeln('--------------------------------');
    for (final line in bill.lines) {
      buffer.writeln(
        '${line.item.name} x${line.quantity}  Rs ${line.total.toStringAsFixed(0)}',
      );
    }
    buffer
      ..writeln('--------------------------------')
      ..writeln('Subtotal: Rs ${bill.subtotal.toStringAsFixed(0)}')
      ..writeln('GST 5%: Rs ${bill.gst.toStringAsFixed(0)}')
      ..writeln('Discount: Rs ${bill.discount.toStringAsFixed(0)}')
      ..writeln('Grand Total: Rs ${bill.total.toStringAsFixed(0)}')
      ..writeln('Paid by: ${bill.paymentMode.label}');
    return buffer.toString();
  }
}

class _MenuSection extends StatelessWidget {
  const _MenuSection({
    required this.categories,
    required this.selectedCategory,
    required this.items,
    required this.state,
    required this.onCategoryChanged,
  });

  final List<String> categories;
  final String selectedCategory;
  final List<MenuItem> items;
  final OrdersState state;
  final ValueChanged<String> onCategoryChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Menu Items',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            SizedBox(
              width: 280,
              child: TextField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search item',
                ),
                onChanged: (value) {
                  context.read<OrdersBloc>().add(OrderSearchChanged(value));
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: categories.map((category) {
            return FilterChip(
              label: Text(category),
              selected: selectedCategory == category,
              onSelected: (_) => onCategoryChanged(category),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: items.isEmpty
              ? const _EmptyMenu()
              : GridView.builder(
                  itemCount: items.length,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 240,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    mainAxisExtent: 234,
                  ),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _MenuCard(
                      item: item,
                      quantity: state.quantityFor(item.id),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({required this.item, required this.quantity});

  final MenuItem item;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 92,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.secondary.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.restaurant,
                color: AppTheme.primary.withValues(alpha: 0.82),
                size: 42,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              item.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Rs ${item.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: AppTheme.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                FilledButton.icon(
                  onPressed: () {
                    context.read<OrdersBloc>().add(
                      OrderItemIncremented(item.id),
                    );
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(quantity == 0 ? 'Add' : '$quantity'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CartSection extends StatelessWidget {
  const _CartSection({required this.state});

  final OrdersState state;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cart & Billing',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            SegmentedButton<OrderType>(
              segments: OrderType.values
                  .map(
                    (type) =>
                        ButtonSegment(value: type, label: Text(type.label)),
                  )
                  .toList(),
              selected: {state.selectedOrderType},
              onSelectionChanged: (selection) {
                context.read<OrdersBloc>().add(
                  OrderTypeStarted(selection.first),
                );
              },
            ),
            const SizedBox(height: 12),
            _CustomerFields(state: state),
            const SizedBox(height: 14),
            SizedBox(
              height: 190,
              child: state.lines.isEmpty
                  ? const _EmptyCart()
                  : ListView.separated(
                      itemCount: state.lines.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1),
                      itemBuilder: (context, index) =>
                          _CartLineTile(line: state.lines[index]),
                    ),
            ),
            const SizedBox(height: 14),
            _BillBreakdown(state: state),
            const SizedBox(height: 14),
            SegmentedButton<PaymentMode>(
              segments: PaymentMode.values
                  .map(
                    (mode) =>
                        ButtonSegment(value: mode, label: Text(mode.label)),
                  )
                  .toList(),
              selected: {state.paymentMode},
              onSelectionChanged: (selection) {
                context.read<OrdersBloc>().add(
                  OrderPaymentModeChanged(selection.first),
                );
              },
            ),
            const SizedBox(height: 14),
            ReceiptPreview(
              lines: state.lines,
              orderType: state.selectedOrderType,
              paymentMode: state.paymentMode,
              subtotal: state.subtotal,
              gst: state.gst,
              discount: state.discount,
              total: state.total,
              tableNumber: state.tableNumber,
              customerName: state.customerName,
              customerPhone: state.customerPhone,
            ),
            const SizedBox(height: 14),
            _ActionButtons(state: state),
          ],
        ),
      ),
    );
  }
}

class _CustomerFields extends StatelessWidget {
  const _CustomerFields({required this.state});

  final OrdersState state;

  @override
  Widget build(BuildContext context) {
    if (state.selectedOrderType == OrderType.dineIn) {
      return TextField(
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.table_restaurant),
          labelText: 'Table number',
        ),
        onChanged: (value) {
          context.read<OrdersBloc>().add(OrderTableChanged(value));
        },
      );
    }

    if (state.selectedOrderType == OrderType.delivery) {
      return Row(
        children: [
          Expanded(
            child: TextField(
              decoration: const InputDecoration(labelText: 'Customer name'),
              onChanged: (value) {
                context.read<OrdersBloc>().add(
                  OrderCustomerChanged(
                    customerName: value,
                    customerPhone: state.customerPhone,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone'),
              onChanged: (value) {
                context.read<OrdersBloc>().add(
                  OrderCustomerChanged(
                    customerName: state.customerName,
                    customerPhone: value,
                  ),
                );
              },
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}

class _CartLineTile extends StatelessWidget {
  const _CartLineTile({required this.line});

  final OrderLine line;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line.item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                Text(
                  'Rs ${line.item.price.toStringAsFixed(0)} each',
                  style: const TextStyle(color: AppTheme.mutedText),
                ),
              ],
            ),
          ),
          IconButton.filledTonal(
            tooltip: 'Decrease',
            onPressed: () {
              context.read<OrdersBloc>().add(
                OrderItemDecremented(line.item.id),
              );
            },
            icon: const Icon(Icons.remove),
          ),
          SizedBox(
            width: 34,
            child: Text(
              line.quantity.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
          IconButton.filled(
            tooltip: 'Increase',
            onPressed: () {
              context.read<OrdersBloc>().add(
                OrderItemIncremented(line.item.id),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

class _BillBreakdown extends StatelessWidget {
  const _BillBreakdown({required this.state});

  final OrdersState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _AmountRow(label: 'Subtotal', value: state.subtotal),
        _AmountRow(label: 'Tax / GST (5%)', value: state.gst),
        const SizedBox(height: 8),
        TextField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Discount',
            prefixText: 'Rs ',
          ),
          onChanged: (value) {
            context.read<OrdersBloc>().add(OrderDiscountChanged(value));
          },
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: _AmountRow(
            label: 'Grand Total',
            value: state.total,
            isTotal: true,
          ),
        ),
      ],
    );
  }
}

class _AmountRow extends StatelessWidget {
  const _AmountRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  final String label;
  final double value;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      color: isTotal ? AppTheme.primary : AppTheme.text,
      fontSize: isTotal ? 20 : 14,
      fontWeight: isTotal ? FontWeight.w900 : FontWeight.w700,
    );
    return Row(
      children: [
        Expanded(child: Text(label, style: style)),
        Text('Rs ${value.toStringAsFixed(0)}', style: style),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({required this.state});

  final OrdersState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: state.lines.isEmpty
                    ? null
                    : () {
                        context.read<OrdersBloc>().add(const OrderCleared());
                      },
                icon: const Icon(Icons.delete_outline),
                label: const Text('Clear Cart'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: state.lines.isEmpty
                    ? null
                    : () {
                        context.read<OrdersBloc>().add(const OrderCleared());
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Order moved to hold')),
                        );
                      },
                icon: const Icon(Icons.pause_circle_outline),
                label: const Text('Hold Order'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: FilledButton.icon(
            onPressed: state.lines.isEmpty
                ? null
                : () {
                    context.read<OrdersBloc>().add(const OrderSubmitted());
                  },
            icon: const Icon(Icons.print),
            label: const Text('Generate Bill / Print'),
          ),
        ),
      ],
    );
  }
}

class _HistoryView extends StatelessWidget {
  const _HistoryView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, state) {
        if (state.bills.isEmpty) {
          return const Center(child: Text('No bills yet today'));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: state.bills.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final bill = state.bills[index];
            return Card(
              margin: EdgeInsets.zero,
              child: ListTile(
                title: Text(
                  '${bill.orderType.label}  Rs ${bill.total.toStringAsFixed(0)}',
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                subtitle: Text(
                  '${bill.lines.length} items | ${bill.paymentMode.label} | GST Rs ${bill.gst.toStringAsFixed(0)}',
                ),
                trailing: Text(
                  '${bill.createdAt.hour.toString().padLeft(2, '0')}:${bill.createdAt.minute.toString().padLeft(2, '0')}',
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _EmptyMenu extends StatelessWidget {
  const _EmptyMenu();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('No menu items in this category'));
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Cart is empty',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: AppTheme.mutedText,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
