import 'package:equatable/equatable.dart';

enum OnboardingStep {
  welcome,
  language,
  businessType,
  referralSource,
  businessSetup,
}

final class OnboardingState extends Equatable {
  const OnboardingState({
    this.step = OnboardingStep.welcome,
    this.role = 'Owner Login',
    this.language = 'English',
    this.businessType = 'Restaurant',
    this.referralSource = 'Instagram',
    this.hasThermalPrinter = false,
  });

  final OnboardingStep step;
  final String role;
  final String language;
  final String businessType;
  final String referralSource;
  final bool hasThermalPrinter;

  double get progress {
    if (step == OnboardingStep.welcome) return 0;
    return step.index / (OnboardingStep.values.length - 1);
  }

  bool get canGoBack => step != OnboardingStep.welcome;

  OnboardingState copyWith({
    OnboardingStep? step,
    String? role,
    String? language,
    String? businessType,
    String? referralSource,
    bool? hasThermalPrinter,
  }) {
    return OnboardingState(
      step: step ?? this.step,
      role: role ?? this.role,
      language: language ?? this.language,
      businessType: businessType ?? this.businessType,
      referralSource: referralSource ?? this.referralSource,
      hasThermalPrinter: hasThermalPrinter ?? this.hasThermalPrinter,
    );
  }

  @override
  List<Object?> get props => [
    step,
    role,
    language,
    businessType,
    referralSource,
    hasThermalPrinter,
  ];
}
