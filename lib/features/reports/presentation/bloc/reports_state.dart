part of 'reports_bloc.dart';

final class ReportsState extends Equatable {
  const ReportsState({
    this.totalSales = 0,
    this.billCount = 0,
    this.paymentBreakdown = const {},
    this.topItems = const [],
  });

  final double totalSales;
  final int billCount;
  final Map<PaymentMode, double> paymentBreakdown;
  final List<MapEntry<String, int>> topItems;

  @override
  List<Object?> get props => [
    totalSales,
    billCount,
    paymentBreakdown,
    topItems,
  ];
}
