import 'package:equatable/equatable.dart';

enum OrderType { dineIn, parcel, delivery }

enum PaymentMode { cash, card, upi, split }

extension OrderTypeLabel on OrderType {
  String get label {
    return switch (this) {
      OrderType.dineIn => 'Dine-In',
      OrderType.parcel => 'Parcel',
      OrderType.delivery => 'Delivery',
    };
  }
}

extension PaymentModeLabel on PaymentMode {
  String get label {
    return switch (this) {
      PaymentMode.cash => 'Cash',
      PaymentMode.card => 'Card',
      PaymentMode.upi => 'UPI',
      PaymentMode.split => 'Split',
    };
  }
}

final class MenuItem extends Equatable {
  const MenuItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.isVeg,
  });

  final String id;
  final String name;
  final String category;
  final double price;
  final bool isVeg;

  MenuItem copyWith({
    String? id,
    String? name,
    String? category,
    double? price,
    bool? isVeg,
  }) {
    return MenuItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      isVeg: isVeg ?? this.isVeg,
    );
  }

  @override
  List<Object?> get props => [id, name, category, price, isVeg];
}

final class OrderLine extends Equatable {
  const OrderLine({required this.item, required this.quantity, this.note = ''});

  final MenuItem item;
  final int quantity;
  final String note;

  double get total => item.price * quantity;

  OrderLine copyWith({MenuItem? item, int? quantity, String? note}) {
    return OrderLine(
      item: item ?? this.item,
      quantity: quantity ?? this.quantity,
      note: note ?? this.note,
    );
  }

  @override
  List<Object?> get props => [item, quantity, note];
}

final class Bill extends Equatable {
  const Bill({
    required this.id,
    required this.orderType,
    required this.lines,
    required this.createdAt,
    required this.paymentMode,
    this.tableNumber,
    this.customerName = '',
    this.customerPhone = '',
    this.discount = 0,
  });

  final String id;
  final OrderType orderType;
  final String? tableNumber;
  final String customerName;
  final String customerPhone;
  final List<OrderLine> lines;
  final DateTime createdAt;
  final PaymentMode paymentMode;
  final double discount;

  double get subtotal => lines.fold(0, (total, line) => total + line.total);
  double get gst => subtotal * 0.05;
  double get total => (subtotal + gst - discount).clamp(0, double.infinity);

  int quantityFor(String itemId) {
    return lines
        .where((line) => line.item.id == itemId)
        .fold(0, (total, line) => total + line.quantity);
  }

  @override
  List<Object?> get props => [
    id,
    orderType,
    tableNumber,
    customerName,
    customerPhone,
    lines,
    createdAt,
    paymentMode,
    discount,
  ];
}
