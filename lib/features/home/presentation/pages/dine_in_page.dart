import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resturent_billinng_app/app/app_theme.dart';
import 'package:resturent_billinng_app/core/models/restaurant_models.dart';
import 'package:resturent_billinng_app/features/menu/presentation/pages/menu_page.dart';
import 'package:resturent_billinng_app/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:resturent_billinng_app/features/orders/presentation/pages/orders_page.dart';

class DineInPage extends StatefulWidget {
  const DineInPage({super.key});

  @override
  State<DineInPage> createState() => _DineInPageState();
}

class _DineInPageState extends State<DineInPage> {
  final List<_FloorInfo> _floors = [_FloorInfo(name: '1Floor', tableCount: 1)];

  int _selectedFloorIndex = 0;

  _FloorInfo get _selectedFloor => _floors[_selectedFloorIndex];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Dine In', style: TextStyle(fontSize: 20)),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () => setState(() {}),
            icon: const Icon(Icons.refresh_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _FloorRail(
            floors: _floors,
            selectedIndex: _selectedFloorIndex,
            onSelected: (index) => setState(() => _selectedFloorIndex = index),
            onAddFloor: _addFloor,
          ),
          Expanded(
            child: Column(
              children: [
                const _StatusLegend(),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      final crossAxisCount = width >= 720 ? 4 : 3;
                      return GridView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
                        itemCount: _selectedFloor.tableCount + 1,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: 18,
                          crossAxisSpacing: 18,
                          childAspectRatio: 1.05,
                        ),
                        itemBuilder: (context, index) {
                          if (index == _selectedFloor.tableCount) {
                            return _AddTableTile(onTap: _addTable);
                          }
                          final tableNumber = index + 1;
                          final status = _statusFor(tableNumber);
                          return _TableTile(
                            number: tableNumber,
                            status: status,
                            onTap: () => _openMenuForTable(tableNumber),
                            onDelete: () => _deleteTable(tableNumber),
                          );
                        },
                      );
                    },
                  ),
                ),
                SafeArea(
                  top: false,
                  child: TextButton.icon(
                    onPressed: _floors.length == 1 ? null : _deleteFloor,
                    icon: const Icon(Icons.delete_rounded),
                    label: const Text('Delete Floor'),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFD65C5C),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _TableStatus _statusFor(int tableNumber) {
    if (_selectedFloorIndex == 1 && tableNumber == 1) {
      return const _TableStatus(
        color: Color(0xFFD83B31),
        background: Color(0xFFFFECEA),
        label: 'Not Available',
        time: '04:07',
      );
    }
    if (_selectedFloorIndex == 0 && tableNumber == 5) {
      return const _TableStatus(
        color: Color(0xFF4A9EF0),
        background: Color(0xFFEAF4FF),
        label: 'Bill Printed',
      );
    }
    return const _TableStatus(
      color: Color(0xFF49B440),
      background: Color(0xFFEFF8EC),
      label: 'Available',
    );
  }

  void _openMenuForTable(int tableNumber) {
    final tableLabel =
        '${_selectedFloor.name} - ${tableNumber.toString().padLeft(2, '0')}';
    context.read<OrdersBloc>()
      ..add(const OrderTypeStarted(OrderType.dineIn))
      ..add(OrderTableChanged(tableLabel));
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MenuPage(
          initialOrderType: OrderType.dineIn,
          initialTableNumber: tableLabel,
        ),
      ),
    );
  }

  void _addFloor() {
    setState(() {
      _floors.add(
        _FloorInfo(name: 'Floor ${_floors.length + 1}', tableCount: 1),
      );
      _selectedFloorIndex = _floors.length - 1;
    });
  }

  void _addTable() {
    setState(() {
      _floors[_selectedFloorIndex] = _selectedFloor.copyWith(
        tableCount: _selectedFloor.tableCount + 1,
      );
    });
  }

  void _deleteTable(int tableNumber) {
    if (tableNumber < 1 || tableNumber > _selectedFloor.tableCount) return;
    setState(() {
      _floors[_selectedFloorIndex] = _selectedFloor.copyWith(
        tableCount: _selectedFloor.tableCount - 1,
      );
    });
  }

  void _deleteFloor() {
    setState(() {
      _floors.removeAt(_selectedFloorIndex);
      if (_selectedFloorIndex >= _floors.length) {
        _selectedFloorIndex = _floors.length - 1;
      }
    });
  }
}

class _FloorRail extends StatelessWidget {
  const _FloorRail({
    required this.floors,
    required this.selectedIndex,
    required this.onSelected,
    required this.onAddFloor,
  });

  final List<_FloorInfo> floors;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final VoidCallback onAddFloor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Color(0xFFF0E7DF))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var index = 0; index < floors.length; index++)
            _FloorButton(
              floor: floors[index],
              isSelected: selectedIndex == index,
              onTap: () => onSelected(index),
            ),
          _AddFloorButton(onTap: onAddFloor),
        ],
      ),
    );
  }
}

class _FloorButton extends StatelessWidget {
  const _FloorButton({
    required this.floor,
    required this.isSelected,
    required this.onTap,
  });

  final _FloorInfo floor;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 100,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: isSelected ? const Color(0xFFFFFBF6) : Colors.white,
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              floor.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: Color(0xFF18181B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${floor.tableCount} Tables',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF6B625D),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddFloorButton extends StatelessWidget {
  const _AddFloorButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 90,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          border: Border.symmetric(
            horizontal: BorderSide(color: Color(0xFFF0E7DF)),
          ),
        ),
        child: const Text(
          '+ Add Floor',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppTheme.primary,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _StatusLegend extends StatelessWidget {
  const _StatusLegend();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF0E7DF))),
      ),
      child: const Row(
        children: [
          _LegendDot(color: Color(0xFFEFF8EC), label: 'Available'),
          SizedBox(width: 18),
          _LegendDot(color: Color(0xFFFFECEA), label: 'Not Available'),
          SizedBox(width: 18),
          _LegendDot(color: Color(0xFFEAF4FF), label: 'Bill Printed'),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Color(0xFF3D3835),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TableTile extends StatelessWidget {
  const _TableTile({
    required this.number,
    required this.status,
    required this.onTap,
    required this.onDelete,
  });

  final int number;
  final _TableStatus status;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: status.background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: status.color.withValues(alpha: 0.12)),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                child: PopupMenuButton<_TableAction>(
                  tooltip: 'Table actions',
                  icon: Icon(
                    Icons.more_vert_rounded,
                    color: status.color,
                    size: 26,
                  ),
                  onSelected: (action) {
                    if (action == _TableAction.delete) onDelete();
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: _TableAction.delete,
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline_rounded,
                            color: Color(0xFFD65C5C),
                            size: 20,
                          ),
                          SizedBox(width: 10),
                          Text('Delete Table'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 28, 12, 12),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: number.toString().padLeft(2, '0'),
                            style: TextStyle(
                              color: status.color,
                              fontSize: 40,
                              fontWeight: FontWeight.w900,
                              height: 1,
                            ),
                          ),
                          if (status.time != null)
                            TextSpan(
                              text: '\n${status.time}',
                              style: const TextStyle(
                                color: Color(0xFF3D3835),
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                height: 1.2,
                              ),
                            ),
                        ],
                      ),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddTableTile extends StatelessWidget {
  const _AddTableTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: const Color(0xFFF4F4F4),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.add_rounded,
            color: Color(0xFFD6D6D6),
            size: 36,
          ),
        ),
      ),
    );
  }
}

class _FloorInfo {
  const _FloorInfo({required this.name, required this.tableCount});

  final String name;
  final int tableCount;

  _FloorInfo copyWith({String? name, int? tableCount}) {
    return _FloorInfo(
      name: name ?? this.name,
      tableCount: tableCount ?? this.tableCount,
    );
  }
}

class _TableStatus {
  const _TableStatus({
    required this.color,
    required this.background,
    required this.label,
    this.time,
  });

  final Color color;
  final Color background;
  final String label;
  final String? time;
}

enum _TableAction { delete }
