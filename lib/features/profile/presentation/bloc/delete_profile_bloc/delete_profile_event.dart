

import 'package:equatable/equatable.dart';

abstract class DeleteProfileEvent extends Equatable {
  const DeleteProfileEvent();

  @override
  List<Object> get props => [];
}

class DeleteProfileSubmitted extends DeleteProfileEvent {
  final String password;

  const DeleteProfileSubmitted({required this.password});

  @override
  List<Object> get props => [password];
}
