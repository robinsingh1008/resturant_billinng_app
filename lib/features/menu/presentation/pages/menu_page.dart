import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resturent_billinng_app/app/app_theme.dart';
import 'package:resturent_billinng_app/core/constants/app_colors.dart';
import 'package:resturent_billinng_app/core/models/restaurant_models.dart';
import 'package:resturent_billinng_app/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:resturent_billinng_app/features/orders/presentation/widgets/receipt_preview.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key, this.initialOrderType, this.initialTableNumber});

  final OrderType? initialOrderType;
  final String? initialTableNumber;

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  static const _categories = ['Breakfast', 'Grocery'];

  String _selectedCategory = 'Breakfast';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _applyInitialOrderSelection();
  }

  @override
  void didUpdateWidget(covariant MenuPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialOrderType != widget.initialOrderType ||
        oldWidget.initialTableNumber != widget.initialTableNumber) {
      _applyInitialOrderSelection();
    }
  }

  void _applyInitialOrderSelection() {
    final initialOrderType = widget.initialOrderType;
    if (initialOrderType == null) return;
    final ordersBloc = context.read<OrdersBloc>()
      ..add(OrderTypeStarted(initialOrderType));
    final tableNumber = widget.initialTableNumber;
    if (tableNumber != null && tableNumber.trim().isNotEmpty) {
      ordersBloc.add(OrderTableChanged(tableNumber));
    }
  }

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
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,

          title: const Text(
            'Main Menu',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          actions: [
            BlocBuilder<OrdersBloc, OrdersState>(
              buildWhen: (previous, current) =>
                  previous.lines != current.lines ||
                  previous.selectedOrderType != current.selectedOrderType ||
                  previous.tableNumber != current.tableNumber,
              builder: (context, state) {
                return IconButton(
                  tooltip: 'Cart & billing',
                  onPressed: () => _showCartSheet(context, state),
                  icon: Badge.count(
                    count: state.lines.length,
                    isLabelVisible: state.lines.isNotEmpty,
                    child: const Icon(Icons.tune_rounded, size: 28),
                  ),
                );
              },
            ),
            IconButton(
              tooltip: 'Search item',
              onPressed: () {
                setState(() => _isSearching = !_isSearching);
                if (_isSearching) return;
                context.read<OrdersBloc>().add(const OrderSearchChanged(''));
              },
              icon: Icon(
                _isSearching ? Icons.close_rounded : Icons.search_rounded,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
        body: BlocBuilder<OrdersBloc, OrdersState>(
          builder: (context, state) {
            final menu = _filteredItems(state);
            return Column(
              children: [
                if (_isSearching)
                  _SearchBar(
                    onChanged: (value) {
                      context.read<OrdersBloc>().add(OrderSearchChanged(value));
                    },
                  ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _MenuCategoryRail(
                        categories: _categories,
                        selectedCategory: _selectedCategory,
                        onCategoryChanged: (category) {
                          setState(() => _selectedCategory = category);
                        },
                        onAddCategory: _showAddCategoryMessage,
                      ),
                      Expanded(
                        child: _MenuSection(items: menu, state: state),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<MenuItem> _filteredItems(OrdersState state) {
    final sampleItems = _sampleItemsFor(_selectedCategory);
    final query = state.searchQuery.trim().toLowerCase();
    if (query.isEmpty) return sampleItems;
    return sampleItems
        .where((item) => item.name.toLowerCase().contains(query))
        .toList(growable: false);
  }

  List<MenuItem> _sampleItemsFor(String category) {
    if (category == 'Grocery') {
      return const [
        MenuItem(
          id: 'menu_grocery_1',
          name: 'Rice',
          category: 'Grocery',
          price: 80,
          isVeg: true,
        ),
        MenuItem(
          id: 'menu_grocery_2',
          name: 'Atta',
          category: 'Grocery',
          price: 55,
          isVeg: true,
        ),
      ];
    }
    return const [
      MenuItem(
        id: 'menu_breakfast_1',
        name: 'Burger',
        category: 'Breakfast',
        price: 69,
        isVeg: true,
      ),
      MenuItem(
        id: 'menu_breakfast_2',
        name: 'Kaju Katli',
        category: 'Breakfast',
        price: 900,
        isVeg: true,
      ),
      MenuItem(
        id: 'menu_breakfast_3',
        name: 'Margherita Pizza',
        category: 'Breakfast',
        price: 220,
        isVeg: true,
      ),
      MenuItem(
        id: 'menu_breakfast_4',
        name: 'Tea',
        category: 'Breakfast',
        price: 10,
        isVeg: true,
      ),
    ];
  }

  void _showCartSheet(BuildContext context, OrdersState state) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (_) {
        return BlocBuilder<OrdersBloc, OrdersState>(
          builder: (context, currentState) {
            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.84,
              minChildSize: 0.45,
              maxChildSize: 0.94,
              builder: (context, scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: _CartSection(state: currentState),
                );
              },
            );
          },
        );
      },
    );
  }

  void _showAddCategoryMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Category add option selected')),
    );
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

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFEDEDED))),
      ),
      child: TextField(
        autofocus: true,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        decoration: const InputDecoration(
          hintText: 'Search item',
          prefixIcon: Icon(Icons.search_rounded),
        ),
        onChanged: onChanged,
      ),
    );
  }
}

class _MenuCategoryRail extends StatelessWidget {
  const _MenuCategoryRail({
    required this.categories,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.onAddCategory,
  });

  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategoryChanged;
  final VoidCallback onAddCategory;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Color(0xFFEDEDED))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final category in categories)
            _CategoryTile(
              title: category,
              isSelected: selectedCategory == category,
              onTap: () => onCategoryChanged(category),
            ),
          _AddCategoryTile(onTap: onAddCategory),
        ],
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 80,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          border: const Border(bottom: BorderSide(color: Color(0xFFEDEDED))),
        ),
        child: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _AddCategoryTile extends StatelessWidget {
  const _AddCategoryTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 90,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Color(0xFFEDEDED))),
        ),
        child: const Text(
          '+ Add\nCategory',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color.fromARGB(255, 55, 55, 55),
            fontSize: 12,
            fontWeight: FontWeight.w900,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  const _MenuSection({required this.items, required this.state});

  final List<MenuItem> items;
  final OrdersState state;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const _EmptyMenu();

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(18, 34, 18, 18),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 28,
        crossAxisSpacing: 18,
        mainAxisExtent: 180,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return _MenuCard(item: item, quantity: state.quantityFor(item.id));
      },
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({required this.item, required this.quantity});

  final MenuItem item;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        context.read<OrdersBloc>().add(OrderMenuItemAdded(item));
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${item.name} added')));
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 2,
            left: 8,
            child: Row(
              children: [
                _VegMarker(isVeg: item.isVeg),
                SizedBox(width: 5),
                Text(
                  '₹${item.price.toStringAsFixed(1)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF3C3D4C),
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),

          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 100,
              height: 90,
              margin: const EdgeInsets.only(top: 40),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE0E0E0), width: 10),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.image_rounded,
                color: Color(0xFFE0E0E0),
                size: 62,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 55,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  quantity == 0 ? item.name : '${item.name}  x$quantity',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    height: 1.15,
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

class _VegMarker extends StatelessWidget {
  const _VegMarker({required this.isVeg});

  final bool isVeg;

  @override
  Widget build(BuildContext context) {
    final color = isVeg ? const Color(0xFF28A745) : const Color(0xFFD65C5C);
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: color, width: 2),
      ),
      child: Center(
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
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
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            SegmentedButton<OrderType>(
              segments: OrderType.values
                  .map(
                    (type) => ButtonSegment(
                      value: type,
                      label: Text(
                        type.label,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
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
                    (mode) => ButtonSegment(
                      value: mode,
                      label: Text(
                        mode.label,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
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
        style: const TextStyle(fontSize: 16),
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
              style: const TextStyle(fontSize: 16),
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
              style: const TextStyle(fontSize: 16),
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
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'Rs ${line.item.price.toStringAsFixed(0)} each',
                  style: const TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 16,
                  ),
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
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
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
          style: const TextStyle(fontSize: 16),
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
      fontSize: isTotal ? 20 : 16,
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
                label: const Text('Clear Cart', style: TextStyle(fontSize: 16)),
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
                label: const Text('Hold Order', style: TextStyle(fontSize: 16)),
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
            label: const Text(
              'Generate Bill / Print',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyMenu extends StatelessWidget {
  const _EmptyMenu();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'No menu items in this category',
        style: TextStyle(fontSize: 16),
      ),
    );
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
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
