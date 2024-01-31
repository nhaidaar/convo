part of 'call_bloc.dart';

sealed class CallEvent extends Equatable {
  const CallEvent();

  @override
  List<Object> get props => [];
}

class GetCallListEvent extends CallEvent {}
