
import 'package:equatable/equatable.dart';

abstract class DeleteProfileState extends Equatable {
  const DeleteProfileState();

  @override
  List<Object> get props => [];
}

class DeleteProfileInitial extends DeleteProfileState {}

class DeleteProfileLoading extends DeleteProfileState {}

class DeleteProfileSuccess extends DeleteProfileState {
  final String message;

  const DeleteProfileSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class DeleteProfileFailure extends DeleteProfileState {
  final String error;

  const DeleteProfileFailure({required this.error});

  @override
  List<Object> get props => [error];
}
