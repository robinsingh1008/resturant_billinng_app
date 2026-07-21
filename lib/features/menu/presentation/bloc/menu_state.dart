part of 'menu_bloc.dart';

final class MenuState extends Equatable {
  const MenuState({this.items = const []});

  final List<MenuItem> items;

  @override
  List<Object?> get props => [items];
}
