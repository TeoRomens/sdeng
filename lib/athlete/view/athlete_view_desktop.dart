import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:sdeng/athlete/cubit/athlete_cubit.dart';
import 'package:sdeng/athlete/view/view.dart';

class AthleteViewDesktop extends StatefulWidget {
  const AthleteViewDesktop({super.key});

  @override
  AthleteDetailsDesktopState createState() => AthleteDetailsDesktopState();
}

class AthleteDetailsDesktopState extends State<AthleteViewDesktop>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 3, vsync: this); // Note: 3 tabs for the right column
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<AthleteCubit>();
    final athlete = bloc.state.athlete;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                AthleteInfoCard(
                  name: athlete?.fullName ?? 'Loading...',
                  taxCode: athlete?.taxCode ?? 'Loading...',
                ),
                const Expanded(
                  child: AthleteInfo(),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                const SizedBox(height: 16),
                SizedBox(
                  height: 36,
                  child: TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(icon: Icon(FeatherIcons.heart)),
                      Tab(icon: Icon(FeatherIcons.dollarSign)),
                      Tab(icon: Icon(FeatherIcons.file)),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: const [
                      MedicalInfo(),
                      PaymentInfo(),
                      DocumentInfo(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
