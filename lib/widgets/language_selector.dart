import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguageSelector extends StatefulWidget {
  const LanguageSelector({super.key});

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  Future<void> _showLanguageSheet() async {
    final selected = await showModalBottomSheet<Locale>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          _LanguageBottomSheet(selectedLocale: context.locale),
    );

    if (selected == null || !mounted) return;
    await context.setLocale(selected);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: _showLanguageSheet,
        child: Container(
          height: 30,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFF3D7DCC), width: 1.4),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'अ',
                  style: TextStyle(
                    color: Color(0xFF3D7DCC),
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
              ),
              Container(
                width: 25,
                height: 25,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFF3D7DCC),
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  'A',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    height: 1,
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

class _LanguageBottomSheet extends StatelessWidget {
  const _LanguageBottomSheet({required this.selectedLocale});

  final Locale selectedLocale;

  static const List<_LanguageOption> _languages = [
    _LanguageOption(locale: Locale('en'), code: 'En', name: 'English'),
    _LanguageOption(locale: Locale('hi'), code: 'हिं', name: 'हिन्दी'),
    _LanguageOption(locale: Locale('mr'), code: 'म', name: 'मराठी'),
    _LanguageOption(locale: Locale('bn'), code: 'বা', name: 'বাংলা'),
    _LanguageOption(locale: Locale('kn'), code: 'ಕ', name: 'ಕನ್ನಡ'),
    _LanguageOption(locale: Locale('ta'), code: 'த', name: 'தமிழ்'),
    _LanguageOption(locale: Locale('te'), code: 'తె', name: 'తెలుగు'),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,

          padding: EdgeInsets.fromLTRB(24, 28, 24, bottomPadding + 34),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'language.choose_language'.tr(),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  height: 1.16,
                ),
              ),
              const SizedBox(height: 28),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18,
                  mainAxisExtent: 50,
                ),
                itemCount: _languages.length,
                itemBuilder: (context, index) {
                  final language = _languages[index];
                  return _LanguageTile(
                    language: language,
                    isSelected:
                        language.locale.languageCode ==
                        selectedLocale.languageCode,
                    onTap: () => Navigator.of(context).pop(language.locale),
                  );
                },
              ),
            ],
          ),
        ),
        Positioned(
          right: 18,
          top: 0,
          child: Material(
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => Navigator.of(context).pop(),
              child: const SizedBox(
                width: 48,
                height: 48,
                child: Icon(Icons.close, color: Colors.black, size: 24),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  final _LanguageOption language;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected
        ? const Color(0xFF126DE5)
        : const Color(0xFFE0E0E0);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(34),
      child: InkWell(
        borderRadius: BorderRadius.circular(34),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(34),
            border: Border.all(
              color: borderColor,
              width: isSelected ? 1.7 : 1.4,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 30,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFFF2F8FF),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  language.code,
                  style: const TextStyle(
                    color: Color(0xFF1D67B7),
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  language.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    height: 1,
                  ),
                ),
              ),
              if (isSelected) ...[
                const SizedBox(width: 8),
                Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Color(0xFF3DB07D),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 14),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageOption {
  const _LanguageOption({
    required this.locale,
    required this.code,
    required this.name,
  });

  final Locale locale;
  final String code;
  final String name;
}
