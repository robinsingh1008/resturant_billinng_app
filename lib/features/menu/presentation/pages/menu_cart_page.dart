import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resturent_billinng_app/app/app_theme.dart';
import 'package:resturent_billinng_app/core/constants/app_colors.dart';
import 'package:resturent_billinng_app/core/models/restaurant_models.dart';
import 'package:resturent_billinng_app/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:resturent_billinng_app/widgets/custom_text_input_bottom_sheet.dart';

class MenuCartPage extends StatelessWidget {
  const MenuCartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersBloc, OrdersState>(
      listenWhen: (previous, current) =>
          previous.submittedBill != current.submittedBill &&
          current.submittedBill != null,
      listener: (context, state) {
        Navigator.of(context).maybePop();
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text(
              'Packing',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Order moved to hold')),
                    );
                  },
                  icon: const Icon(Icons.pause_rounded, size: 18),
                  label: const Text(
                    'Hold',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primary,
                    side: const BorderSide(color: AppTheme.primary, width: 1.2),
                    minimumSize: const Size(104, 42),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                    children: [
                      _AddCustomerButton(state: state),
                      const SizedBox(height: 26),
                      if (state.lines.isEmpty)
                        const _EmptyCartMessage()
                      else
                        ...state.lines.map((line) => _CartItemRow(line: line)),
                      const SizedBox(height: 16),
                      const Divider(height: 32, color: Color(0xFFECECEC)),
                      _TotalRow(
                        label: 'Non-Taxable Value',
                        value: state.subtotal,
                      ),
                      const SizedBox(height: 14),
                      _TotalRow(label: 'Total Payable', value: state.total),
                      const SizedBox(height: 26),
                      Center(
                        child: TextButton.icon(
                          onPressed: state.lines.isEmpty
                              ? null
                              : () => context.read<OrdersBloc>().add(
                                  const OrderCleared(),
                                ),
                          icon: const Icon(Icons.delete, size: 18),
                          label: const Text(
                            'Delete',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _BottomActions(state: state),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AddCustomerButton extends StatelessWidget {
  const _AddCustomerButton({required this.state});

  final OrdersState state;

  @override
  Widget build(BuildContext context) {
    final hasCustomer = state.customerName.trim().isNotEmpty;
    return OutlinedButton.icon(
      onPressed: () async {
        final name = await showCustomTextInputBottomSheet(
          context: context,
          title: 'Add Customer',
          hintText: 'Enter customer name',
          initialValue: state.customerName,
        );
        if (name == null || !context.mounted) return;
        context.read<OrdersBloc>().add(
          OrderCustomerChanged(
            customerName: name,
            customerPhone: state.customerPhone,
          ),
        );
      },
      icon: Icon(hasCustomer ? Icons.person_rounded : Icons.add_rounded),
      label: Text(
        hasCustomer ? state.customerName : 'Add Customer',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: hasCustomer ? AppTheme.primary : AppTheme.mutedText,
        minimumSize: const Size.fromHeight(55),
        side: BorderSide(
          color: hasCustomer ? AppTheme.primary : AppTheme.border,
          width: 1.4,
        ),
      ),
    );
  }
}

class _CartItemRow extends StatelessWidget {
  const _CartItemRow({required this.line});

  final OrderLine line;

  @override
  Widget build(BuildContext context) {
    final item = line.item;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _VegMarker(isVeg: item.isVeg),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (line.note.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    line.note,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFFCFCFCF),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 10),
          _QuantityStepper(line: line),
          const SizedBox(width: 14),
          SizedBox(
            width: 74,
            child: Text(
              '₹${line.total.toStringAsFixed(0)}',
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  const _QuantityStepper({required this.line});

  final OrderLine line;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 100,
      decoration: BoxDecoration(
        color: AppTheme.primary.withValues(alpha: 0.08),
        border: Border.all(
          color: AppTheme.primary.withValues(alpha: 0.45),
          width: 1.4,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _StepperButton(
            icon: Icons.remove_rounded,
            onTap: () {
              context.read<OrdersBloc>().add(
                OrderItemDecremented(line.item.id),
              );
            },
          ),
          Expanded(
            child: Text(
              line.quantity.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.primary,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          _StepperButton(
            icon: Icons.add_rounded,
            onTap: () {
              context.read<OrdersBloc>().add(
                OrderItemIncremented(line.item.id),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 42,
      height: 44,
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: onTap,
        icon: Icon(icon, color: AppTheme.primary, size: 22),
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({required this.label, required this.value});

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF3D4052),
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Text(
          '₹${value.toStringAsFixed(2)}',
          style: const TextStyle(
            color: Color(0xFF3D4052),
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _BottomActions extends StatelessWidget {
  const _BottomActions({required this.state});

  final OrdersState state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _SquareActionButton(
                icon: Icons.receipt_long_rounded,
                backgroundColor: AppTheme.primary,
                onTap: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('KOT ready')));
                },
              ),
              const SizedBox(width: 16),
              _SquareActionButton(
                icon: Icons.percent_rounded,
                backgroundColor: AppTheme.secondary,
                onTap: () {
                  context.read<OrdersBloc>().add(
                    const OrderDiscountChanged('0'),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.border),
            ),
            child: Row(
              children: PaymentMode.values.map((mode) {
                return Expanded(
                  child: _PaymentModeOption(
                    mode: mode,
                    selected: state.paymentMode == mode,
                    onTap: () {
                      context.read<OrdersBloc>().add(
                        OrderPaymentModeChanged(mode),
                      );
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _BottomButton(
                  label: 'Print KOT',
                  isSecondary: true,
                  onTap: state.lines.isEmpty ? null : () {},
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _BottomButton(
                  label: 'Print Bill',
                  onTap: state.lines.isEmpty
                      ? null
                      : () {
                          context.read<OrdersBloc>().add(
                            const OrderSubmitted(),
                          );
                        },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _BottomButton(
                  label: 'Save',
                  onTap: state.lines.isEmpty
                      ? null
                      : () {
                          context.read<OrdersBloc>().add(
                            const OrderSubmitted(),
                          );
                        },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaymentModeOption extends StatelessWidget {
  const _PaymentModeOption({
    required this.mode,
    required this.selected,
    required this.onTap,
  });

  final PaymentMode mode;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppTheme.primary : AppTheme.mutedText,
                  width: 2.2,
                ),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: const BoxDecoration(
                          color: AppTheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                mode.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SquareActionButton extends StatelessWidget {
  const _SquareActionButton({
    required this.icon,
    required this.onTap,
    required this.backgroundColor,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 64,
      child: FilledButton(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor,
          disabledBackgroundColor: AppTheme.border,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Icon(icon, size: 28),
      ),
    );
  }
}

class _BottomButton extends StatelessWidget {
  const _BottomButton({
    required this.label,
    required this.onTap,
    this.isSecondary = false,
  });

  final String label;
  final VoidCallback? onTap;
  final bool isSecondary;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: FilledButton(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: isSecondary ? AppTheme.secondary : AppTheme.primary,
          disabledBackgroundColor: AppTheme.border,
          foregroundColor: Colors.white,
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}

class _VegMarker extends StatelessWidget {
  const _VegMarker({required this.isVeg});

  final bool isVeg;

  @override
  Widget build(BuildContext context) {
    final color = isVeg ? const Color(0xFF2FA84F) : const Color(0xFFD65C5C);
    return Container(
      width: 15,
      height: 15,
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: color, width: 2),
      ),
      child: Center(
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
      ),
    );
  }
}

class _EmptyCartMessage extends StatelessWidget {
  const _EmptyCartMessage();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Text(
          'Cart is empty',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
