part of 'home_bloc.dart';

final class HomeState extends Equatable {
  const HomeState({this.todaySalesTotal = 0, this.todayOrderCount = 0});

  final double todaySalesTotal;
  final int todayOrderCount;

  @override
  List<Object?> get props => [todaySalesTotal, todayOrderCount];
}
