import 'package:resturent_billinng_app/core/models/restaurant_models.dart';

class OrderRepository {
  final List<Bill> _bills = [];

  List<Bill> getBills() {
    final bills = [..._bills]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return List.unmodifiable(bills);
  }

  List<Bill> getBillsForDay(DateTime day) {
    return getBills()
        .where((bill) {
          return bill.createdAt.year == day.year &&
              bill.createdAt.month == day.month &&
              bill.createdAt.day == day.day;
        })
        .toList(growable: false);
  }

  void addBill(Bill bill) {
    _bills.add(bill);
  }
}
