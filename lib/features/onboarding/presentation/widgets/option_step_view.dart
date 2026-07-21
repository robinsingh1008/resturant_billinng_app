import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resturent_billinng_app/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:resturent_billinng_app/features/onboarding/presentation/bloc/onboarding_event.dart';
import 'package:resturent_billinng_app/features/onboarding/presentation/widgets/onboarding_scaffold.dart';

class OptionStepView extends StatelessWidget {
  const OptionStepView({
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.onSelected,
    this.columns = 1,
    super.key,
  });

  final String title;
  final List<String> options;
  final String selectedValue;
  final ValueChanged<String> onSelected;
  final int columns;

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      bottomButtonText: 'Next',
      onBottomPressed: () {
        context.read<OnboardingBloc>().add(const OnboardingNextPressed());
      },
      child: ListView(
        padding: const EdgeInsets.only(top: 54, bottom: 24),
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: Colors.black,
              fontSize: 31,
              height: 1.22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 34),
          if (columns == 1)
            ...options.map(
              (option) => Padding(
                padding: const EdgeInsets.only(bottom: 19),
                child: _OptionCard(
                  label: option,
                  selected: option == selectedValue,
                  onTap: () => onSelected(option),
                ),
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: options.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 3.35,
              ),
              itemBuilder: (context, index) {
                final option = options[index];
                return _OptionCard(
                  label: option,
                  selected: option == selectedValue,
                  centered: true,
                  onTap: () => onSelected(option),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
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
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          height: 70,
          alignment: centered ? Alignment.center : Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 32),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? Colors.black : const Color(0xFFE0E0E0),
              width: selected ? 2.7 : 1.4,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x30000000),
                blurRadius: 0,
                offset: Offset(0, 7),
              ),
            ],
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
