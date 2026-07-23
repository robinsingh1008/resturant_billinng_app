import 'package:resturent_billinng_app/core/models/restaurant_models.dart';

class OrderRepository {
  final List<Bill> _bills = [];

  List<Bill> getBills() {
    final bills = [..._bills]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return List.unmodifiable(bills);
  }

  List<Bill> getBillsForDay(DateTime day) {
    final start = DateTime(day.year, day.month, day.day);
    final end = DateTime(day.year, day.month, day.day, 23, 59, 59, 999, 999);
    return getBills()
        .where((bill) {
          return !bill.createdAt.isBefore(start) &&
              !bill.createdAt.isAfter(end);
        })
        .toList(growable: false);
  }

  void addBill(Bill bill) {
    _bills.add(bill);
  }
}
