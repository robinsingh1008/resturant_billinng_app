part of 'menu_bloc.dart';

sealed class MenuEvent extends Equatable {
  const MenuEvent();

  @override
  List<Object?> get props => [];
}

final class MenuStarted extends MenuEvent {
  const MenuStarted();
}

final class MenuItemSaved extends MenuEvent {
  const MenuItemSaved(this.item);

  final MenuItem item;

  @override
  List<Object?> get props => [item];
}

final class MenuItemDeleted extends MenuEvent {
  const MenuItemDeleted(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}
