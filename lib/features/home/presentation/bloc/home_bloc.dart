import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resturent_billinng_app/core/repositories/order_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._orderRepository) : super(const HomeState()) {
    on<HomeStarted>((event, emit) => _emitSummary(emit));
  }

  final OrderRepository _orderRepository;

  void _emitSummary(Emitter<HomeState> emit) {
    final now = DateTime.now();
    final bills = _orderRepository.getBillsForDay(now);
    final total = bills.fold<double>(0, (sum, bill) => sum + bill.total);
    emit(
      HomeState(
        todaySalesTotal: total,
        todayOrderCount: bills.length,
        lastUpdatedAt: now,
      ),
    );
  }
}
