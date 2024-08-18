import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:sdeng/athlete/cubit/athlete_cubit.dart';
import 'package:sdeng/athlete/view/view.dart';

/// A desktop view for displaying detailed information about an athlete.
///
/// This view is split into two columns:
/// - The left column displays basic athlete information and personal details.
/// - The right column contains a [TabBar] that allows navigation between
///   medical information, payment details, and documents.
class AthleteViewDesktop extends StatefulWidget {
  const AthleteViewDesktop({super.key});

  @override
  AthleteDetailsDesktopState createState() => AthleteDetailsDesktopState();
}

class AthleteDetailsDesktopState extends State<AthleteViewDesktop>
    with TickerProviderStateMixin {
  /// The [TabController] for managing the tabs in the right column of the view.
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Initialize the TabController with 3 tabs for the right column.
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    // Obtain the current state of AthleteCubit.
    final bloc = context.watch<AthleteCubit>();
    // Extract the athlete details from the cubit state.
    final athlete = bloc.state.athlete;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: [
          // Left column: Displays athlete's basic information and personal details.
          Expanded(
            flex: 1,
            child: Column(
              children: [
                AthleteInfoCard(
                  name: athlete?.fullName ?? 'Loading...',
                  taxCode: athlete?.taxCode ?? 'Loading...',
                ),
                const Expanded(
                  child: AthleteInfo(), // Widget to display athlete's personal details
                ),
              ],
            ),
          ),
          // Right column: Contains a TabBar and TabBarView for additional information.
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
                      Tab(icon: Icon(FeatherIcons.heart)),      // Medical information tab
                      Tab(icon: Icon(FeatherIcons.dollarSign)), // Payment details tab
                      Tab(icon: Icon(FeatherIcons.file)),       // Documents tab
                    ],
                  ),
                ),
                // TabBarView to display content of the selected tab.
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: const [
                      MedicalInfo(),   // Widget to display medical information
                      PaymentInfo(),   // Widget to display payment details
                      DocumentInfo(),  // Widget to display documents
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
