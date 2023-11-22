import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/ui/payments_expires/view/responsive.dart';
import 'package:sdeng/ui/reports/bloc/events_bloc.dart';
import 'package:sdeng/ui/reports/view/components/med_team_list.dart';
import 'package:sdeng/ui/reports/view/shimmer.dart';
import 'package:sdeng/util/text_util.dart';

class EventsDesktop extends StatelessWidget {
  const EventsDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => EventsBloc()..loadMedExpires()..loadPaymentExpires(),
      child: Row(
        children: [
          const Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Visite Mediche',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  MedTeamList(),
                ]
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Stato Pagamenti',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  BlocBuilder<EventsBloc, EventsState>(
                      builder: (context, state) {
                        if(state.paymentsStatus == PaymentsStatus.loaded) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 3.0),
                                child: ListTile(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)
                                  ),
                                  tileColor: state.paymentExpiredList.isNotEmpty
                                      ? const Color(0xFFFF4040)
                                      : const Color(0xFF5EBE4F),
                                  leading: state.paymentExpiredList.isNotEmpty
                                      ? const Icon(Icons.warning_rounded, color: Colors.white,)
                                      : const Icon(Icons.check_circle_rounded, color: Colors.white,),
                                  title: state.paymentExpiredList.isNotEmpty
                                      ? Text('${state.paymentExpiredList.length} expired payments',
                                    style: const TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal
                                    ),)
                                      : const Text('All payments are regular',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.white,
                                    ),),
                                  trailing: state.paymentExpiredList.isNotEmpty
                                      ? const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white,)
                                      : null,
                                  onTap: () {
                                    state.paymentExpiredList.isNotEmpty
                                        ? Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => PaymentExpires(paymentsList: state.paymentExpiredList),
                                            ),
                                          ) : null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 15,),
                              ListTile(
                                dense: true,
                                tileColor: Colors.transparent,
                                leading: const Text('Prima Rata',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                trailing: Text('${state.numPrimaRataPaid}/${state.totalAthletes}',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                              ListTile(
                                dense: true,
                                tileColor: Colors.transparent,
                                leading: const Text('Seconda Rata',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                trailing: Text('${state.numSecRataPaid}/${state.totalAthletes}',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                              ListTile(
                                dense: true,
                                tileColor: Colors.transparent,
                                leading: const Text('Rata Unica',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                trailing: Text('${state.numRataUnPaid}/${state.totalAthletes}',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20,),
                              IntrinsicHeight(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Cashed",
                                          style: TextStyle(
                                              color: Colors.black45
                                          ),
                                        ),
                                        Text(
                                          '€ ${TextUtils.abbreviateK(state.cashed)}',
                                          style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w600
                                          ),
                                        ),
                                      ],
                                    ),
                                    const VerticalDivider(
                                      width: 20,
                                      thickness: 1,
                                      color: Colors.grey,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Players",
                                          style: TextStyle(
                                              color: Colors.black45
                                          ),
                                        ),
                                        Text(
                                          state.totalAthletes.toString(),
                                          style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w600
                                          ),
                                        ),
                                      ],
                                    ),
                                    const VerticalDivider(
                                      width: 20,
                                      thickness: 1,
                                      color: Colors.grey,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Cash Left",
                                          style: TextStyle(
                                              color: Colors.black45
                                          ),
                                        ),
                                        Text(
                                          '€ ${TextUtils.abbreviateK(state.cashLeft)}',
                                          style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w600
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                        else if(state.paymentsStatus == PaymentsStatus.loading){
                          return ConstrainedBox(
                              constraints: const BoxConstraints(maxHeight: 300),
                              child: const ShimmerLoader()
                          );
                        }
                        else {
                          return const Text('Error');
                        }
                      }
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}