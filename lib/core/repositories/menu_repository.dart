import 'package:resturent_billinng_app/core/models/restaurant_models.dart';

class MenuRepository {
  MenuRepository()
    : _items = [
        const MenuItem(
          id: '1',
          name: 'Paneer Tikka',
          category: 'Starters',
          price: 145,
          isVeg: true,
        ),
        const MenuItem(
          id: '2',
          name: 'Paneer Butter Masala',
          category: 'Main Course',
          price: 160,
          isVeg: true,
        ),
        const MenuItem(
          id: '3',
          name: 'Dal Tadka',
          category: 'Main Course',
          price: 110,
          isVeg: true,
        ),
        const MenuItem(
          id: '4',
          name: 'Crispy Corn',
          category: 'Starters',
          price: 120,
          isVeg: true,
        ),
        const MenuItem(
          id: '5',
          name: 'Chicken Curry',
          category: 'Main Course',
          price: 190,
          isVeg: false,
        ),
        const MenuItem(
          id: '6',
          name: 'Fresh Lime Soda',
          category: 'Drinks',
          price: 60,
          isVeg: true,
        ),
        const MenuItem(
          id: '7',
          name: 'Gulab Jamun',
          category: 'Desserts',
          price: 75,
          isVeg: true,
        ),
        const MenuItem(
          id: '8',
          name: 'Cold Coffee',
          category: 'Drinks',
          price: 95,
          isVeg: true,
        ),
      ];

  final List<MenuItem> _items;

  List<MenuItem> getItems() => List.unmodifiable(_items);

  void upsertItem(MenuItem item) {
    final index = _items.indexWhere((entry) => entry.id == item.id);
    if (index == -1) {
      _items.add(item);
    } else {
      _items[index] = item;
    }
  }

  void deleteItem(String id) {
    _items.removeWhere((item) => item.id == id);
  }
}
