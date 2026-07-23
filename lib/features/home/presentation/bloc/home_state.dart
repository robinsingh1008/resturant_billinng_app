part of 'home_bloc.dart';

final class HomeState extends Equatable {
  const HomeState({
    this.todaySalesTotal = 0,
    this.todayOrderCount = 0,
    this.lastUpdatedAt,
  });

  final double todaySalesTotal;
  final int todayOrderCount;
  final DateTime? lastUpdatedAt;

  @override
  List<Object?> get props => [todaySalesTotal, todayOrderCount, lastUpdatedAt];
}
