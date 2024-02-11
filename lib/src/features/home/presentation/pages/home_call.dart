import 'package:convo/src/features/home/presentation/widgets/card_call.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../call/bloc/call_bloc.dart';
import '../../../../constants/theme.dart';

class HomeCall extends StatelessWidget {
  const HomeCall({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => CallBloc()..add(GetCallListEvent()),
        child: BlocBuilder<CallBloc, CallState>(
          builder: (context, state) {
            if (state is GetCallListSuccess) {
              if (state.data.isEmpty) {
                return Center(
                  child: Text(
                    'Empty call history!\nTime to dial in, create memorable calls.',
                    style: mediumTS,
                    textAlign: TextAlign.center,
                  ),
                );
              }

              List<CallCard> calls = state.data.map((callModel) {
                return CallCard(model: callModel);
              }).toList();

              calls.sort(
                (a, b) => b.model.callAt!.compareTo(a.model.callAt!),
              );

              return ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: calls,
              );
            }
            return Center(
              child: CircularProgressIndicator(
                color: blue,
              ),
            );
          },
        ),
      ),
    );
  }
}
