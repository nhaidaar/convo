part of 'call_bloc.dart';

sealed class CallState extends Equatable {
  const CallState();

  @override
  List<Object> get props => [];
}

final class CallInitial extends CallState {}

final class CallLoading extends CallState {}

final class CallSuccess extends CallState {}

final class CallError extends CallState {
  final String e;
  const CallError(this.e);

  @override
  List<Object> get props => [e];
}

final class GetCallListSuccess extends CallState {
  final List<CallModel> data;
  const GetCallListSuccess(this.data);

  @override
  List<Object> get props => [data];
}
