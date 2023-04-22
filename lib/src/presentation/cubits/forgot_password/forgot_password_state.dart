part of 'forgot_password_cubit.dart';

abstract class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();

  @override
  List<Object> get props => [];
}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordLoading extends ForgotPasswordState {}

class ForgotPasswordLoaded extends ForgotPasswordState {
  final bool isEmailVerified;
  final bool canEmailSend;
  final String status;
  ForgotPasswordLoaded(
      {required this.isEmailVerified,
      required this.canEmailSend,
      required this.status});
}
