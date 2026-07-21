import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resturent_billinng_app/core/models/restaurant_models.dart';
import 'package:resturent_billinng_app/core/repositories/menu_repository.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc(this._menuRepository) : super(const MenuState()) {
    on<MenuStarted>((event, emit) => _emitItems(emit));
    on<MenuItemSaved>(_onItemSaved);
    on<MenuItemDeleted>(_onItemDeleted);
  }

  final MenuRepository _menuRepository;

  void _onItemSaved(MenuItemSaved event, Emitter<MenuState> emit) {
    _menuRepository.upsertItem(event.item);
    _emitItems(emit);
  }

  void _onItemDeleted(MenuItemDeleted event, Emitter<MenuState> emit) {
    _menuRepository.deleteItem(event.id);
    _emitItems(emit);
  }

  void _emitItems(Emitter<MenuState> emit) {
    emit(MenuState(items: _menuRepository.getItems()));
  }
}
