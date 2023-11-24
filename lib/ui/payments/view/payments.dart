import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/common/player_tile.dart';
import 'package:sdeng/ui/payments/bloc/payments_bloc.dart';
import 'package:sdeng/ui/payments/view/payments_mobile.dart';

class Payments extends StatelessWidget {
  const Payments({Key? key}) : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payments',
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
      ),
      body: BlocProvider(
        create: (BuildContext context) => PaymentsBloc()..load(),
        child: const PaymentsMobile(),
      ),
    );
  }
}
