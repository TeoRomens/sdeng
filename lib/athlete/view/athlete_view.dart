import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:sdeng/athlete/cubit/athlete_cubit.dart';
import 'package:sdeng/athlete/view/view.dart';

class AthleteView extends StatefulWidget {
  const AthleteView({super.key});

  @override
  AthleteDetailsMobileState createState() => AthleteDetailsMobileState();
}

class AthleteDetailsMobileState extends State<AthleteView> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<AthleteCubit>();
    final athlete = bloc.state.athlete;

    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverToBoxAdapter(
          child: AthleteInfoCard(
            name: athlete?.fullName ?? 'Loading...',
            taxCode: athlete?.taxCode ?? 'Loading...',
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 36,
            child: TabBar(
              controller: _tabController,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              splashBorderRadius: BorderRadius.circular(8),
              tabs: const [
                Tab(icon: Icon(FeatherIcons.user)),
                Tab(icon: Icon(FeatherIcons.heart)),
                Tab(icon: Icon(FeatherIcons.dollarSign)),
                Tab(icon: Icon(FeatherIcons.file)),
              ],
            ),
          ),
        ),
      ],
      body: TabBarView(
        controller: _tabController,
        children: const [
          AthleteInfo(),
          MedicalInfo(),
          PaymentInfo(),
          DocumentInfo(),
        ],
      ),
    );
  }
}
