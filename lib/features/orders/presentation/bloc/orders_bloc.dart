import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resturent_billinng_app/core/models/restaurant_models.dart';
import 'package:resturent_billinng_app/core/repositories/menu_repository.dart';
import 'package:resturent_billinng_app/core/repositories/order_repository.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc(this._menuRepository, this._orderRepository)
    : super(
        OrdersState(
          menuItems: _menuRepository.getItems(),
          bills: _orderRepository.getBills(),
        ),
      ) {
    on<OrdersStarted>((event, emit) => _refresh(emit));
    on<OrderTypeStarted>(_onOrderTypeStarted);
    on<OrderSearchChanged>(
      (event, emit) => emit(state.copyWith(searchQuery: event.query)),
    );
    on<OrderItemIncremented>(_onItemIncremented);
    on<OrderItemDecremented>(_onItemDecremented);
    on<OrderDiscountChanged>(_onDiscountChanged);
    on<OrderPaymentModeChanged>(
      (event, emit) => emit(state.copyWith(paymentMode: event.paymentMode)),
    );
    on<OrderTableChanged>(
      (event, emit) => emit(state.copyWith(tableNumber: event.tableNumber)),
    );
    on<OrderCustomerChanged>(_onCustomerChanged);
    on<OrderSubmitted>(_onSubmitted);
    on<OrderCleared>((event, emit) => emit(_emptyState()));
  }

  final MenuRepository _menuRepository;
  final OrderRepository _orderRepository;

  void _onOrderTypeStarted(OrderTypeStarted event, Emitter<OrdersState> emit) {
    emit(
      _emptyState().copyWith(
        selectedOrderType: event.orderType,
        selectedTab: OrdersTab.newOrder,
      ),
    );
  }

  void _onItemIncremented(
    OrderItemIncremented event,
    Emitter<OrdersState> emit,
  ) {
    final item = state.menuItems.firstWhere((entry) => entry.id == event.id);
    final lines = [...state.lines];
    final index = lines.indexWhere((line) => line.item.id == event.id);
    if (index == -1) {
      lines.add(OrderLine(item: item, quantity: 1));
    } else {
      lines[index] = lines[index].copyWith(quantity: lines[index].quantity + 1);
    }
    emit(state.copyWith(lines: lines, submittedBill: null));
  }

  void _onItemDecremented(
    OrderItemDecremented event,
    Emitter<OrdersState> emit,
  ) {
    final lines = [...state.lines];
    final index = lines.indexWhere((line) => line.item.id == event.id);
    if (index == -1) return;
    final line = lines[index];
    if (line.quantity <= 1) {
      lines.removeAt(index);
    } else {
      lines[index] = line.copyWith(quantity: line.quantity - 1);
    }
    emit(state.copyWith(lines: lines, submittedBill: null));
  }

  void _onDiscountChanged(
    OrderDiscountChanged event,
    Emitter<OrdersState> emit,
  ) {
    emit(state.copyWith(discount: double.tryParse(event.value) ?? 0));
  }

  void _onCustomerChanged(
    OrderCustomerChanged event,
    Emitter<OrdersState> emit,
  ) {
    emit(
      state.copyWith(
        customerName: event.customerName,
        customerPhone: event.customerPhone,
      ),
    );
  }

  void _onSubmitted(OrderSubmitted event, Emitter<OrdersState> emit) {
    if (state.lines.isEmpty) return;
    final bill = Bill(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      orderType: state.selectedOrderType,
      tableNumber: state.tableNumber.trim().isEmpty ? null : state.tableNumber,
      customerName: state.customerName,
      customerPhone: state.customerPhone,
      lines: state.lines,
      createdAt: DateTime.now(),
      paymentMode: state.paymentMode,
      discount: state.discount,
    );
    _orderRepository.addBill(bill);
    emit(_emptyState().copyWith(submittedBill: bill));
  }

  void _refresh(Emitter<OrdersState> emit) {
    emit(
      state.copyWith(
        menuItems: _menuRepository.getItems(),
        bills: _orderRepository.getBills(),
      ),
    );
  }

  OrdersState _emptyState() {
    return OrdersState(
      menuItems: _menuRepository.getItems(),
      bills: _orderRepository.getBills(),
      selectedOrderType: state.selectedOrderType,
    );
  }
}
