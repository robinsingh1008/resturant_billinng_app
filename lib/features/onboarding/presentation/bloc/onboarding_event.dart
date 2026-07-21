import 'package:equatable/equatable.dart';

sealed class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

final class RoleSelected extends OnboardingEvent {
  const RoleSelected(this.role);

  final String role;

  @override
  List<Object?> get props => [role];
}

final class LanguageSelected extends OnboardingEvent {
  const LanguageSelected(this.language);

  final String language;

  @override
  List<Object?> get props => [language];
}

final class BusinessTypeSelected extends OnboardingEvent {
  const BusinessTypeSelected(this.businessType);

  final String businessType;

  @override
  List<Object?> get props => [businessType];
}

final class ReferralSourceSelected extends OnboardingEvent {
  const ReferralSourceSelected(this.referralSource);

  final String referralSource;

  @override
  List<Object?> get props => [referralSource];
}

final class PrinterAvailabilitySelected extends OnboardingEvent {
  const PrinterAvailabilitySelected(this.hasThermalPrinter);

  final bool hasThermalPrinter;

  @override
  List<Object?> get props => [hasThermalPrinter];
}

final class OnboardingNextPressed extends OnboardingEvent {
  const OnboardingNextPressed();
}

final class OnboardingBackPressed extends OnboardingEvent {
  const OnboardingBackPressed();
}
