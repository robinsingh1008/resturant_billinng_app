import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resturent_billinng_app/app/app_theme.dart';
import 'package:resturent_billinng_app/core/models/restaurant_models.dart';

class ReceiptPreview extends StatelessWidget {
  const ReceiptPreview({
    required this.lines,
    required this.orderType,
    required this.paymentMode,
    required this.subtotal,
    required this.gst,
    required this.discount,
    required this.total,
    this.billId,
    this.tableNumber,
    this.customerName = '',
    this.customerPhone = '',
    this.createdAt,
    super.key,
  });

  final List<OrderLine> lines;
  final OrderType orderType;
  final PaymentMode paymentMode;
  final double subtotal;
  final double gst;
  final double discount;
  final double total;
  final String? billId;
  final String? tableNumber;
  final String customerName;
  final String customerPhone;
  final DateTime? createdAt;

  @override
  Widget build(BuildContext context) {
    final mono = GoogleFonts.robotoMono(
      color: AppTheme.text,
      fontSize: 12,
      height: 1.35,
      fontWeight: FontWeight.w500,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: DefaultTextStyle(
        style: mono,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'RESTAURANT BILLING',
              textAlign: TextAlign.center,
              style: mono.copyWith(fontWeight: FontWeight.w800, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              '${orderType.label}${billId == null ? '' : '  #${billId!.substring(0, 6)}'}',
              textAlign: TextAlign.center,
            ),
            if (tableNumber != null && tableNumber!.trim().isNotEmpty)
              Text('Table: ${tableNumber!.trim()}'),
            if (customerPhone.trim().isNotEmpty)
              Text('Customer: ${customerName.trim()} ${customerPhone.trim()}'),
            if (createdAt != null) Text(_formatDate(createdAt!)),
            const _DividerLine(),
            if (lines.isEmpty)
              const Text('No items added yet')
            else
              ...lines.map((line) => _ReceiptLine(line: line)),
            const _DividerLine(),
            _AmountLine(label: 'Subtotal', value: subtotal),
            _AmountLine(label: 'GST 5%', value: gst),
            _AmountLine(label: 'Discount', value: -discount),
            const _DividerLine(),
            _AmountLine(label: 'TOTAL', value: total, isTotal: true),
            const SizedBox(height: 8),
            Text('Payment: ${paymentMode.label}', textAlign: TextAlign.center),
            const SizedBox(height: 4),
            const Text('Thank you. Visit again.', textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute';
  }
}

class _ReceiptLine extends StatelessWidget {
  const _ReceiptLine({required this.line});

  final OrderLine line;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text('${line.item.name} x${line.quantity}')),
          Text('Rs ${line.total.toStringAsFixed(0)}'),
        ],
      ),
    );
  }
}

class _AmountLine extends StatelessWidget {
  const _AmountLine({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  final String label;
  final double value;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    final style = DefaultTextStyle.of(context).style.copyWith(
      fontWeight: isTotal ? FontWeight.w900 : FontWeight.w600,
      color: isTotal ? AppTheme.primary : AppTheme.text,
      fontSize: isTotal ? 14 : 12,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text('Rs ${value.toStringAsFixed(0)}', style: style),
        ],
      ),
    );
  }
}

class _DividerLine extends StatelessWidget {
  const _DividerLine();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Text('--------------------------------'),
    );
  }
}
