// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'signin_cubit.dart';

abstract class SigninState extends Equatable {
  const SigninState();

  @override
  List<Object> get props => [];
}

class SigninInitial extends SigninState {}

class SigninLoading extends SigninState {}

class SigninSuccess extends SigninState {
  final String username;
  final String password;
  SigninSuccess({
    required this.username,
    required this.password,
  });
}

class SigninError extends SigninState {}
