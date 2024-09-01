import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:sdeng/athlete/cubit/athlete_cubit.dart';
import 'package:sdeng/athlete/view/view.dart';

/// A mobile view for displaying detailed information about an athlete.
///
/// This view contains tabs that allow the user to navigate between different
/// types of information related to the athlete, such as personal details,
/// medical information, payment details, and documents.
class AthleteView extends StatefulWidget {
  const AthleteView({super.key});

  @override
  AthleteDetailsMobileState createState() => AthleteDetailsMobileState();
}

class AthleteDetailsMobileState extends State<AthleteView>
    with TickerProviderStateMixin {
  /// The [TabController] for managing the tabs in the view.
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
        // Display athlete's basic information in a card.
        SliverToBoxAdapter(
          child: AthleteInfoCard(
            name: athlete?.fullName ?? 'Loading...',
            taxCode: athlete?.taxCode ?? 'Loading...',
          ),
        ),
        // Create a TabBar for navigating between different sections.
        SliverToBoxAdapter(
          child: SizedBox(
            height: 36,
            child: TabBar(
              controller: _tabController,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              splashBorderRadius: BorderRadius.circular(8),
              tabs: const [
                Tab(icon: Icon(FeatherIcons.user)),       // Personal details tab
                Tab(icon: Icon(FeatherIcons.heart)),      // Medical information tab
                Tab(icon: Icon(FeatherIcons.dollarSign)), // Payment details tab
                Tab(icon: Icon(FeatherIcons.file)),       // Documents tab
              ],
            ),
          ),
        ),
      ],
      body: TabBarView(
        controller: _tabController,
        children: const [
          AthleteInfo(),   // Widget to display athlete's personal information
          MedicalInfo(),   // Widget to display medical information
          PaymentInfo(),   // Widget to display payment information
          DocumentInfo(),  // Widget to display documents
        ],
      ),
    );
  }
}
