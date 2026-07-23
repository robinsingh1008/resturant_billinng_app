part of 'orders_bloc.dart';

enum OrdersTab { newOrder, history }

enum OrdersDateFilter { today, yesterday, date }

final class OrdersState extends Equatable {
  const OrdersState({
    this.menuItems = const [],
    this.bills = const [],
    this.lines = const [],
    this.searchQuery = '',
    this.selectedOrderType = OrderType.dineIn,
    this.tableNumber = '',
    this.customerName = '',
    this.customerPhone = '',
    this.paymentMode = PaymentMode.cash,
    this.discount = 0,
    this.submittedBill,
    this.selectedTab = OrdersTab.history,
    this.dateFilter = OrdersDateFilter.today,
    this.selectedDate,
  });

  final List<MenuItem> menuItems;
  final List<Bill> bills;
  final List<OrderLine> lines;
  final String searchQuery;
  final OrderType selectedOrderType;
  final String tableNumber;
  final String customerName;
  final String customerPhone;
  final PaymentMode paymentMode;
  final double discount;
  final Bill? submittedBill;
  final OrdersTab selectedTab;
  final OrdersDateFilter dateFilter;
  final DateTime? selectedDate;

  List<MenuItem> get filteredItems {
    final query = searchQuery.trim().toLowerCase();
    if (query.isEmpty) return menuItems;
    return menuItems
        .where((item) => item.name.toLowerCase().contains(query))
        .toList(growable: false);
  }

  double get subtotal => lines.fold(0, (sum, line) => sum + line.total);
  double get gst => subtotal * 0.05;
  double get total => (subtotal + gst - discount).clamp(0, double.infinity);

  int quantityFor(String itemId) {
    return lines
        .where((line) => line.item.id == itemId)
        .fold(0, (sum, line) => sum + line.quantity);
  }

  OrdersState copyWith({
    List<MenuItem>? menuItems,
    List<Bill>? bills,
    List<OrderLine>? lines,
    String? searchQuery,
    OrderType? selectedOrderType,
    String? tableNumber,
    String? customerName,
    String? customerPhone,
    PaymentMode? paymentMode,
    double? discount,
    Bill? submittedBill,
    bool clearSubmittedBill = false,
    OrdersTab? selectedTab,
    OrdersDateFilter? dateFilter,
    DateTime? selectedDate,
    bool clearSelectedDate = false,
  }) {
    return OrdersState(
      menuItems: menuItems ?? this.menuItems,
      bills: bills ?? this.bills,
      lines: lines ?? this.lines,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedOrderType: selectedOrderType ?? this.selectedOrderType,
      tableNumber: tableNumber ?? this.tableNumber,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      paymentMode: paymentMode ?? this.paymentMode,
      discount: discount ?? this.discount,
      submittedBill: clearSubmittedBill
          ? null
          : submittedBill ?? this.submittedBill,
      selectedTab: selectedTab ?? this.selectedTab,
      dateFilter: dateFilter ?? this.dateFilter,
      selectedDate: clearSelectedDate
          ? null
          : selectedDate ?? this.selectedDate,
    );
  }

  @override
  List<Object?> get props => [
    menuItems,
    bills,
    lines,
    searchQuery,
    selectedOrderType,
    tableNumber,
    customerName,
    customerPhone,
    paymentMode,
    discount,
    submittedBill,
    selectedTab,
    dateFilter,
    selectedDate,
  ];
}
