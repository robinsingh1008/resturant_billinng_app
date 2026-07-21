import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resturent_billinng_app/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:resturent_billinng_app/features/onboarding/presentation/bloc/onboarding_event.dart';
import 'package:resturent_billinng_app/features/onboarding/presentation/bloc/onboarding_state.dart';

class OnboardingScaffold extends StatelessWidget {
  const OnboardingScaffold({
    required this.child,
    required this.bottomButtonText,
    required this.onBottomPressed,
    this.showProgress = true,
    super.key,
  });

  final Widget child;
  final String bottomButtonText;
  final VoidCallback onBottomPressed;
  final bool showProgress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<OnboardingBloc, OnboardingState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 22),
              child: Column(
                children: [
                  if (showProgress) _StepHeader(state: state),
                  Expanded(child: child),
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
                      onPressed: onBottomPressed,
                      child: Text(bottomButtonText),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _StepHeader extends StatelessWidget {
  const _StepHeader({required this.state});

  final OnboardingState state;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (state.canGoBack)
          IconButton.filled(
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFFF0F0F0),
              foregroundColor: Colors.black,
              fixedSize: const Size(54, 54),
            ),
            onPressed: () {
              context.read<OnboardingBloc>().add(const OnboardingBackPressed());
            },
            icon: const Icon(Icons.arrow_back, size: 30),
          )
        else
          const SizedBox(width: 54, height: 54),
        const SizedBox(width: 18),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              minHeight: 14,
              value: state.progress,
              backgroundColor: const Color(0xFFF1F1F1),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}
