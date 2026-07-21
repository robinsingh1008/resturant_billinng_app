import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resturent_billinng_app/core/di/injection_container.dart';
import 'package:resturent_billinng_app/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:resturent_billinng_app/features/onboarding/presentation/bloc/onboarding_event.dart';
import 'package:resturent_billinng_app/features/onboarding/presentation/bloc/onboarding_state.dart';
import 'package:resturent_billinng_app/features/onboarding/presentation/widgets/business_setup_view.dart';
import 'package:resturent_billinng_app/features/onboarding/presentation/widgets/option_step_view.dart';
import 'package:resturent_billinng_app/features/onboarding/presentation/widgets/welcome_view.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OnboardingBloc>(),
      child: BlocBuilder<OnboardingBloc, OnboardingState>(
        builder: (context, state) {
          return switch (state.step) {
            OnboardingStep.welcome => const WelcomeView(),
            OnboardingStep.language => OptionStepView(
              title: 'What language do you speak?',
              options: const [
                'English',
                'हिंदी',
                'বাংলা',
                'मराठी',
                'ಕನ್ನಡ',
                'తెలుగు',
                'اردو',
                'नेपाली',
                '日本語',
                '한국어',
                'Filipino',
                '简体中文',
              ],
              selectedValue: state.language,
              columns: 2,
              onSelected: (value) {
                context.read<OnboardingBloc>().add(LanguageSelected(value));
              },
            ),
            OnboardingStep.businessType => OptionStepView(
              title: 'What do you run?',
              options: const [
                'Restaurant',
                'Cafe',
                'Cloud Kitchen',
                'Sweet Shop',
                'QSR/ Fast Food',
                'Bakery',
                'Food Truck',
                'Other',
              ],
              selectedValue: state.businessType,
              onSelected: (value) {
                context.read<OnboardingBloc>().add(BusinessTypeSelected(value));
              },
            ),
            OnboardingStep.referralSource => OptionStepView(
              title: 'How did you hear about us?',
              options: const [
                'Instagram',
                'YouTube',
                'Google',
                'Friend',
                'Sales Team',
                'Other',
              ],
              selectedValue: state.referralSource,
              onSelected: (value) {
                context.read<OnboardingBloc>().add(
                  ReferralSourceSelected(value),
                );
              },
            ),
            OnboardingStep.businessSetup => const BusinessSetupView(),
          };
        },
      ),
    );
  }
}
