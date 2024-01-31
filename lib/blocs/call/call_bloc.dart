import 'package:convo/services/call_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:convo/models/call_model.dart';
import 'package:equatable/equatable.dart';

part 'call_event.dart';
part 'call_state.dart';

class CallBloc extends Bloc<CallEvent, CallState> {
  final CallService _callService = CallService();

  CallBloc() : super(CallInitial()) {
    on<GetCallListEvent>(
      (event, emit) async {
        await emit.onEach(
          _callService.streamCallList(),
          onData: (data) => emit(GetCallListSuccess(data)),
          onError: (error, stackTrace) => emit(CallError(error.toString())),
        );
      },
    );
  }
}
