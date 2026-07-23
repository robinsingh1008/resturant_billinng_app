import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resturent_billinng_app/core/constants/app_colors.dart';
import 'package:resturent_billinng_app/core/models/restaurant_models.dart';
import 'package:resturent_billinng_app/features/menu/presentation/pages/menu_cart_page.dart';
import 'package:resturent_billinng_app/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:resturent_billinng_app/features/orders/presentation/widgets/receipt_preview.dart';
import 'package:resturent_billinng_app/widgets/custom_text_input_bottom_sheet.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key, this.initialOrderType, this.initialTableNumber});

  final OrderType? initialOrderType;
  final String? initialTableNumber;

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final List<String> _categories = ['Breakfast', 'Grocery'];
  final List<MenuItem> _customItems = [];

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
                  onPressed: () => _openCartPage(context),
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
            return Stack(
              children: [
                Column(
                  children: [
                    if (_isSearching)
                      _SearchBar(
                        onChanged: (value) {
                          context.read<OrdersBloc>().add(
                            OrderSearchChanged(value),
                          );
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
                            onAddCategory: _showAddCategorySheet,
                            onEditCategory: _showEditCategorySheet,
                            onDeleteCategory: _deleteCategory,
                          ),
                          Expanded(
                            child: _MenuSection(
                              items: menu,
                              state: state,
                              onAddItem: _showAddItemSheet,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (state.lines.isNotEmpty)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 18,
                    child: Center(
                      child: _ViewCartButton(
                        count: state.lines.fold<int>(
                          0,
                          (sum, line) => sum + line.quantity,
                        ),
                        onTap: () => _openCartPage(context),
                      ),
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
    final customItems = _customItems
        .where((item) => item.category == category)
        .toList(growable: false);
    if (category == 'Grocery') {
      return [
        ...customItems,
        const MenuItem(
          id: 'menu_grocery_1',
          name: 'Rice',
          category: 'Grocery',
          price: 80,
          isVeg: true,
        ),
        const MenuItem(
          id: 'menu_grocery_2',
          name: 'Atta',
          category: 'Grocery',
          price: 55,
          isVeg: true,
        ),
      ];
    }
    if (category != 'Breakfast') return customItems;
    return [
      ...customItems,
      const MenuItem(
        id: 'menu_breakfast_1',
        name: 'Burger',
        category: 'Breakfast',
        price: 69,
        isVeg: true,
      ),
      const MenuItem(
        id: 'menu_breakfast_2',
        name: 'Kaju Katli',
        category: 'Breakfast',
        price: 900,
        isVeg: true,
      ),
      const MenuItem(
        id: 'menu_breakfast_3',
        name: 'Margherita Pizza',
        category: 'Breakfast',
        price: 220,
        isVeg: true,
      ),
      const MenuItem(
        id: 'menu_breakfast_4',
        name: 'Tea',
        category: 'Breakfast',
        price: 10,
        isVeg: true,
      ),
    ];
  }

  void _openCartPage(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const MenuCartPage()));
  }

  Future<void> _showEditCategorySheet(String category) async {
    final updatedCategory = await showCustomTextInputBottomSheet(
      context: context,
      title: 'Edit Category',
      hintText: 'Enter category name',
      initialValue: category,
    );
    if (updatedCategory == null || !mounted) return;

    final existingCategory = _findCategory(updatedCategory);
    if (existingCategory != null && existingCategory != category) {
      setState(() => _selectedCategory = existingCategory);
      return;
    }

    setState(() {
      final index = _categories.indexOf(category);
      if (index == -1) return;
      _categories[index] = updatedCategory;
      for (var itemIndex = 0; itemIndex < _customItems.length; itemIndex++) {
        final item = _customItems[itemIndex];
        if (item.category == category) {
          _customItems[itemIndex] = item.copyWith(category: updatedCategory);
        }
      }
      _selectedCategory = updatedCategory;
    });
  }

  void _deleteCategory(String category) {
    if (_categories.length <= 1) return;
    setState(() {
      _categories.remove(category);
      _customItems.removeWhere((item) => item.category == category);
      if (_selectedCategory == category) _selectedCategory = _categories.first;
    });
  }

  Future<void> _showAddCategorySheet() async {
    final category = await showCustomTextInputBottomSheet(
      context: context,
      title: 'Add Category',
      hintText: 'Enter category name',
    );
    if (category == null || !mounted) return;

    final existingCategory = _findCategory(category);
    setState(() {
      if (existingCategory == null) {
        _categories.add(category);
        _selectedCategory = category;
      } else {
        _selectedCategory = existingCategory;
      }
    });
  }

  Future<void> _showAddItemSheet() async {
    final item = await showModalBottomSheet<MenuItem>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddMenuItemSheet(category: _selectedCategory),
    );
    if (item == null || !mounted) return;
    setState(() => _customItems.insert(0, item));
  }

  String? _findCategory(String category) {
    for (final entry in _categories) {
      if (entry.toLowerCase() == category.toLowerCase()) return entry;
    }
    return null;
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
    required this.onEditCategory,
    required this.onDeleteCategory,
  });

  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategoryChanged;
  final VoidCallback onAddCategory;
  final ValueChanged<String> onEditCategory;
  final ValueChanged<String> onDeleteCategory;

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
              onEdit: () => onEditCategory(category),
              onDelete: () => onDeleteCategory(category),
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
    required this.onEdit,
    required this.onDelete,
  });

  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

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
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                  ),
                ),
              ),
            ),
            PopupMenuButton<_CategoryAction>(
              tooltip: 'Category options',
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.more_vert_rounded,
                color: isSelected ? Colors.white : Colors.black,
                size: 20,
              ),
              onSelected: (action) {
                switch (action) {
                  case _CategoryAction.edit:
                    onEdit();
                  case _CategoryAction.delete:
                    onDelete();
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: _CategoryAction.edit,
                  child: Text('Edit Category'),
                ),
                PopupMenuItem(
                  value: _CategoryAction.delete,
                  child: Text('Delete Category'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

enum _CategoryAction { edit, delete }

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
  const _MenuSection({
    required this.items,
    required this.state,
    required this.onAddItem,
  });

  final List<MenuItem> items;
  final OrdersState state;
  final VoidCallback onAddItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: onAddItem,
              icon: const Icon(Icons.add_rounded),
              label: const Text(
                'Add Item',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ),
        Expanded(
          child: items.isEmpty
              ? const _EmptyMenu()
              : GridView.builder(
                  padding: const EdgeInsets.fromLTRB(18, 24, 18, 96),
                  itemCount: items.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 28,
                    crossAxisSpacing: 18,
                    mainAxisExtent: 180,
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
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        SystemSound.play(SystemSoundType.click);
        context.read<OrdersBloc>().add(OrderMenuItemAdded(item));
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

class _ViewCartButton extends StatelessWidget {
  const _ViewCartButton({required this.count, required this.onTap});

  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.shopping_cart_rounded, size: 22),
      label: Text(
        'View Cart ($count)',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
      ),
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size(190, 54),
        padding: const EdgeInsets.symmetric(horizontal: 22),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        elevation: 8,
      ),
    );
  }
}

class _AddMenuItemSheet extends StatefulWidget {
  const _AddMenuItemSheet({required this.category});

  final String category;

  @override
  State<_AddMenuItemSheet> createState() => _AddMenuItemSheetState();
}

class _AddMenuItemSheetState extends State<_AddMenuItemSheet> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  bool _isVeg = true;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, bottomInset + 16),
        child: Container(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add Item',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                autofocus: true,
                textInputAction: TextInputAction.next,
                style: const TextStyle(fontSize: 18),
                decoration: const InputDecoration(hintText: 'Enter item name'),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 18),
                decoration: const InputDecoration(
                  hintText: 'Enter price',
                  prefixText: '₹ ',
                ),
              ),
              const SizedBox(height: 14),
              SwitchListTile(
                value: _isVeg,
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Veg item',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
                onChanged: (value) => setState(() => _isVeg = value),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 54,
                      child: FilledButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFD6D6D6),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: SizedBox(
                      height: 54,
                      child: FilledButton(
                        onPressed: _saveItem,
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        child: const Text(
                          'Save',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveItem() {
    final name = _nameController.text.trim();
    final price = double.tryParse(_priceController.text.trim());
    if (name.isEmpty || price == null) return;
    Navigator.of(context).pop(
      MenuItem(
        id: 'custom_${DateTime.now().microsecondsSinceEpoch}',
        name: name,
        category: widget.category,
        price: price,
        isVeg: _isVeg,
      ),
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
