import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resturent_billinng_app/features/main/presentation/pages/main_shell_page.dart';
import 'package:resturent_billinng_app/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:resturent_billinng_app/features/onboarding/presentation/bloc/onboarding_event.dart';
import 'package:resturent_billinng_app/features/onboarding/presentation/bloc/onboarding_state.dart';

class BusinessSetupView extends StatelessWidget {
  const BusinessSetupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 54, 22, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create your business',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 34),
              const _ImportantNote(),
              const SizedBox(height: 34),
              const _SetupTextField(hint: 'Restaurant Name *'),
              const _SetupTextField(hint: 'Restaurant Address *'),
              const _SetupTextField(hint: 'Pincode *'),
              const _SetupTextField(hint: 'Phone Number *'),
              const Padding(
                padding: EdgeInsets.only(left: 8, bottom: 24),
                child: Text(
                  'Do not write +91 in phone number field',
                  style: TextStyle(color: Color(0xFF5F5F5F), fontSize: 13),
                ),
              ),
              Text(
                'Country',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              const _CountryBox(),
              const SizedBox(height: 28),
              Text(
                'Do you have a thermal printer?',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              const _PrinterSelector(),
              const SizedBox(height: 42),
              const _SetupTextField(hint: 'Referral Code (Optional)'),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 74,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute<void>(
                        builder: (_) => const MainShellPage(),
                      ),
                    );
                  },
                  child: const Text('Finish Setup'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImportantNote extends StatelessWidget {
  const _ImportantNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, size: 32, color: Colors.black),
          const SizedBox(width: 22),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Important Note',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'You will not be able to change these settings later in the app.',
                  style: TextStyle(fontSize: 14, height: 1.25),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SetupTextField extends StatelessWidget {
  const _SetupTextField({required this.hint});

  final String hint;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: TextField(
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: Color(0xFF777777),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 24,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFA8A8A8), width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black, width: 1.8),
          ),
        ),
      ),
    );
  }
}

class _CountryBox extends StatelessWidget {
  const _CountryBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 74,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 36),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFD4D4D4), width: 1.2),
      ),
      child: const Text(
        'India',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _PrinterSelector extends StatelessWidget {
  const _PrinterSelector();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        return Row(
          children: [
            _PrinterOption(
              label: 'Yes',
              selected: state.hasThermalPrinter,
              onTap: () {
                context.read<OnboardingBloc>().add(
                  const PrinterAvailabilitySelected(true),
                );
              },
            ),
            const SizedBox(width: 28),
            _PrinterOption(
              label: 'No',
              selected: !state.hasThermalPrinter,
              onTap: () {
                context.read<OnboardingBloc>().add(
                  const PrinterAvailabilitySelected(false),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class _PrinterOption extends StatelessWidget {
  const _PrinterOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            selected ? Icons.radio_button_checked : Icons.radio_button_off,
            color: Colors.black,
            size: 30,
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
