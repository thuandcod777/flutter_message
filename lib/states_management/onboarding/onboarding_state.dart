import 'package:chat/chat.dart';
import 'package:equatable/equatable.dart';

abstract class OnBoardingState extends Equatable {}

class OnBoardingInitial extends OnBoardingState {
  @override
  List<Object> get props => [];
}

class Loading extends OnBoardingState {
  @override
  List<Object> get props => [];
}

class OnboardingSuccess extends OnBoardingState {
  final User user;

  OnboardingSuccess(this.user);

  @override
  List<Object> get props => [user];
}
