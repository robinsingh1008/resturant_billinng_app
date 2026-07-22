part of 'orders_bloc.dart';

sealed class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object?> get props => [];
}

final class OrdersStarted extends OrdersEvent {
  const OrdersStarted();
}

final class OrderTypeStarted extends OrdersEvent {
  const OrderTypeStarted(this.orderType);

  final OrderType orderType;

  @override
  List<Object?> get props => [orderType];
}

final class OrderSearchChanged extends OrdersEvent {
  const OrderSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

final class OrderItemIncremented extends OrdersEvent {
  const OrderItemIncremented(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

final class OrderMenuItemAdded extends OrdersEvent {
  const OrderMenuItemAdded(this.item);

  final MenuItem item;

  @override
  List<Object?> get props => [item];
}

final class OrderItemDecremented extends OrdersEvent {
  const OrderItemDecremented(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

final class OrderDiscountChanged extends OrdersEvent {
  const OrderDiscountChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

final class OrderPaymentModeChanged extends OrdersEvent {
  const OrderPaymentModeChanged(this.paymentMode);

  final PaymentMode paymentMode;

  @override
  List<Object?> get props => [paymentMode];
}

final class OrderTableChanged extends OrdersEvent {
  const OrderTableChanged(this.tableNumber);

  final String tableNumber;

  @override
  List<Object?> get props => [tableNumber];
}

final class OrderCustomerChanged extends OrdersEvent {
  const OrderCustomerChanged({
    required this.customerName,
    required this.customerPhone,
  });

  final String customerName;
  final String customerPhone;

  @override
  List<Object?> get props => [customerName, customerPhone];
}

final class OrderSubmitted extends OrdersEvent {
  const OrderSubmitted();
}

final class OrderCleared extends OrdersEvent {
  const OrderCleared();
}
