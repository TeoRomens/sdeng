import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/model/payment.dart';
import 'package:sdeng/ui/athlete_details/view/responsive.dart';
import 'package:sdeng/ui/payments_expires/view/shimmer.dart';
import 'package:sdeng/ui/payments_expires/bloc/payments_expires_bloc.dart';

class PayExpiresMobile extends StatelessWidget {
  const PayExpiresMobile({
    super.key,
    required this.paymentsList
  });

  final List<Payment> paymentsList;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PayExpiresBloc, PayExpiresState>(
        builder: (context, state) {
          if (state.status == Status.loading) {
            return const ShimmerLoader();
          }
          else if (state.status == Status.failure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Load Failed'),
                  const SizedBox(height: 8.0,),
                  ElevatedButton(
                    onPressed: () {
                      context.read<PayExpiresBloc>().load(paymentsList);
                    },
                    child: const Text('Reload'),
                  )
                ],
              ),
            );
          }
          else {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<PayExpiresBloc>().load(paymentsList);
              },
              child: SafeArea(
                minimum: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()
                      ),
                      itemCount: state.athletesList.length,
                      itemBuilder: ((context, index) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(5, 8, 5, 8),
                          child: ListTile(
                              tileColor: const Color(0xFFFF4040),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)
                              ),
                              leading: Text(
                                '${state.athletesList[index].number}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              title: Text(
                                '${state.athletesList[index].name} ${state.athletesList[index].surname}',
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                ),
                              ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => AthleteDetails(state.athletesList[index],),
                                ),
                              );
                            },
                          ),
                        );
                      })
                    ),
                  ],
                ),
              ),
            );
          }
        },
      );
  }

  Color calculateTileColor(DateTime expireDate){
    if(DateTime.now().isAfter(expireDate)){
      return const Color(0xFFFF4040);
    }else if(DateTime.now().add(const Duration(days: 30)).isAfter(expireDate)) {
      return const Color(0xFFFFAE6A);
    }
    else {
      return const Color(0xFF5EBE4F);
    }
  }
}
