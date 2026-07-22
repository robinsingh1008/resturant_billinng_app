import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:resturent_billinng_app/config/routes/app_routes.dart';
import 'package:resturent_billinng_app/widgets/app_button.dart';

class BusinessCategoryScreen extends StatefulWidget {
  const BusinessCategoryScreen({super.key});

  @override
  State<BusinessCategoryScreen> createState() => _BusinessCategoryScreenState();
}

class _BusinessCategoryScreenState extends State<BusinessCategoryScreen> {
  static const _categories = [
    'Restaurant',
    'Cafe',
    'Cloud Kitchen',
    'Sweet Shop',
    'QSR/ Fast Food',
    'Bakery',
    'Food Truck',
  ];

  String _selectedCategory = 'Restaurant';

  void _goBack() {
    context.go(AppRoutes.language);
  }

  void _goNext() {
    context.go(AppRoutes.setup);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          onPressed: _goBack,
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 22),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(top: 6, bottom: 24),
                  children: [
                    Text(
                      'What do you run?',
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontSize: 31,
                        height: 1.22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 34),
                    ..._categories.map(
                      (category) => Padding(
                        padding: const EdgeInsets.only(bottom: 19),
                        child: _SelectionTile(
                          label: category,
                          selected: category == _selectedCategory,
                          onTap: () {
                            setState(() => _selectedCategory = category);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AppButton(
                key: ValueKey("otp"),
                buttonText: "Next",
                onPressed: _goNext,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectionTile extends StatelessWidget {
  const _SelectionTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          height: 55,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 32),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected ? colorScheme.primary : theme.dividerColor,
              width: selected ? 2 : 1,
            ),
          ),
          child: Text(
            label,
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 18,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
              color: selected ? colorScheme.primary : colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
