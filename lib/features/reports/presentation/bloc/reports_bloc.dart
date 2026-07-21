import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resturent_billinng_app/core/models/restaurant_models.dart';
import 'package:resturent_billinng_app/core/repositories/order_repository.dart';

part 'reports_event.dart';
part 'reports_state.dart';

class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  ReportsBloc(this._orderRepository) : super(const ReportsState()) {
    on<ReportsStarted>((event, emit) => _emitReport(emit));
  }

  final OrderRepository _orderRepository;

  void _emitReport(Emitter<ReportsState> emit) {
    final bills = _orderRepository.getBillsForDay(DateTime.now());
    final paymentBreakdown = {
      for (final mode in PaymentMode.values)
        mode: bills
            .where((bill) => bill.paymentMode == mode)
            .fold<double>(0, (sum, bill) => sum + bill.total),
    };
    final itemTotals = <String, int>{};
    for (final bill in bills) {
      for (final line in bill.lines) {
        itemTotals[line.item.name] =
            (itemTotals[line.item.name] ?? 0) + line.quantity;
      }
    }
    final topItems = itemTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    emit(
      ReportsState(
        totalSales: bills.fold(0, (sum, bill) => sum + bill.total),
        billCount: bills.length,
        paymentBreakdown: paymentBreakdown,
        topItems: topItems.take(5).toList(growable: false),
      ),
    );
  }
}
