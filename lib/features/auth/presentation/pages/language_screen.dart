import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:resturent_billinng_app/config/routes/app_routes.dart';
import 'package:resturent_billinng_app/widgets/app_button.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  static const _languages = [
    'English',
    'हिंदी',
    'বাংলা',
    'मराठी',
    'ಕನ್ನಡ',
    'తెలుగు',
  ];

  String _selectedLanguage = 'English';

  void _goBack() {
    context.go(AppRoutes.otpScreen);
  }

  void _goNext() {
    context.go(AppRoutes.category);
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(22, 18, 22, 22),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: 36, bottom: 24),
                children: [
                  Text(
                    'What language do you speak?',
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontSize: 31,
                      height: 1.22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 34),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _languages.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: 3.35,
                        ),
                    itemBuilder: (context, index) {
                      final language = _languages[index];
                      return _SelectionTile(
                        label: language,
                        selected: language == _selectedLanguage,
                        centered: true,
                        onTap: () {
                          setState(() => _selectedLanguage = language);
                        },
                      );
                    },
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
    );
  }
}

class _SelectionTile extends StatelessWidget {
  const _SelectionTile({
    required this.label,
    required this.selected,
    required this.onTap,
    this.centered = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool centered;

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
          height: 70,
          alignment: centered ? Alignment.center : Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected ? colorScheme.primary : theme.dividerColor,
              width: selected ? 2 : 1,
            ),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
