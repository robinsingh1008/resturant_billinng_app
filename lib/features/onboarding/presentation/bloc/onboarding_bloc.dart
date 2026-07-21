import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resturent_billinng_app/features/onboarding/presentation/bloc/onboarding_event.dart';
import 'package:resturent_billinng_app/features/onboarding/presentation/bloc/onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(const OnboardingState()) {
    on<RoleSelected>((event, emit) => emit(state.copyWith(role: event.role)));
    on<LanguageSelected>(
      (event, emit) => emit(state.copyWith(language: event.language)),
    );
    on<BusinessTypeSelected>(
      (event, emit) => emit(state.copyWith(businessType: event.businessType)),
    );
    on<ReferralSourceSelected>(
      (event, emit) =>
          emit(state.copyWith(referralSource: event.referralSource)),
    );
    on<PrinterAvailabilitySelected>(
      (event, emit) =>
          emit(state.copyWith(hasThermalPrinter: event.hasThermalPrinter)),
    );
    on<OnboardingNextPressed>(_onNextPressed);
    on<OnboardingBackPressed>(_onBackPressed);
  }

  void _onNextPressed(
    OnboardingNextPressed event,
    Emitter<OnboardingState> emit,
  ) {
    if (state.step == OnboardingStep.businessSetup) return;
    emit(state.copyWith(step: OnboardingStep.values[state.step.index + 1]));
  }

  void _onBackPressed(
    OnboardingBackPressed event,
    Emitter<OnboardingState> emit,
  ) {
    if (!state.canGoBack) return;
    emit(state.copyWith(step: OnboardingStep.values[state.step.index - 1]));
  }
}
