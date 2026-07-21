part of 'reports_bloc.dart';

sealed class ReportsEvent extends Equatable {
  const ReportsEvent();

  @override
  List<Object?> get props => [];
}

final class ReportsStarted extends ReportsEvent {
  const ReportsStarted();
}
