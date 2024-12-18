import 'package:app_ui/app_ui.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/athlete/view/athlete_page.dart';
import 'package:sdeng/athletes_full/athletes.dart';

/// The `AthletesViewDesktop` widget displays a grid of athletes with search
/// functionality and infinite scrolling, specifically designed for desktop
/// screen sizes.
///
/// This widget is a `StatefulWidget` that manages a scroll controller to
/// implement infinite scrolling. It also provides a refresh indicator and a
/// search bar to filter athletes. When the user scrolls near the bottom of the
/// list, more athletes are fetched automatically.
///
/// If there are no athletes available, an empty state is shown with an option
/// to add a new athlete.
class AthletesViewDesktop extends StatefulWidget {
  const AthletesViewDesktop({super.key});

  @override
  State<AthletesViewDesktop> createState() => AthletesViewDesktopState();
}

class AthletesViewDesktopState extends State<AthletesViewDesktop> {
  late final ScrollController _controller;
  int _loadedAthletes = 20;

  @override
  void initState() {
    super.initState();
    // Initialize the scroll controller and add a listener for infinite scrolling.
    _controller = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    // Clean up the scroll controller when the widget is disposed.
    _controller.removeListener(_scrollListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<AthletesPageCubit>();

    return RefreshIndicator.adaptive(
      // Refresh the list of athletes when the user pulls down to refresh.
      onRefresh: () => bloc.getAthletes(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xlg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextBox(
                title: 'All athletes',
                content:
                'Below you find all your registered athletes. Tap on a player to see the details.',
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  0,
                  AppSpacing.xs,
                  0,
                  AppSpacing.sm,
                ),
                child: AppTextFormField(
                  // Search for athletes based on the input text.
                  onChanged: (text) =>
                      context.read<AthletesPageCubit>().searchAthlete(text),
                  prefix: const Icon(FeatherIcons.search),
                  hintText: 'Search',
                ),
              ),
              bloc.state.status == AthletesStatus.loading
                  ? const LoadingBox()
                  : bloc.state.athletes.isEmpty
                  ? EmptyState(
                actionText: 'New athlete',
                onPressed: () {
                  // Show a modal to guide the user on adding a new athlete.
                  showAppModal(
                      context: context,
                      content: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.lg,
                          AppSpacing.lg,
                          AppSpacing.lg,
                          AppSpacing.xlg,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'New Athlete',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium,
                              textAlign: TextAlign.center,
                            ),
                            const Divider(
                                endIndent: 0, indent: 0, height: 25),
                            Padding(
                              padding:
                              const EdgeInsets.all(AppSpacing.sm),
                              child: Text(
                                'To add a new athlete, please go to the team page where you would like to add your athlete',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ));
                },
              )
                  : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 1.82,
                ),
                padding: EdgeInsets.zero,
                itemCount: bloc.state.athletes.length,
                itemBuilder: (_, index) => AthleteCard(
                  title: bloc.state.athletes[index].fullName,
                  content: Text(
                    bloc.state.athletes[index].taxCode,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Inter',
                    ),
                  ),
                  image: Assets.images.logo3.svg(height: 60),
                  action: SecondaryButton(
                    text: 'View',
                    onPressed: () => Navigator.of(context).push(
                        AthletePage.route(
                            athleteId:
                            bloc.state.athletes[index].id)),
                  ),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  /// The scroll listener that triggers loading more athletes when the user
  /// scrolls near the bottom of the list.
  void _scrollListener() {
    if (_controller.position.extentAfter <
        MediaQuery.of(context).size.height - 100) {
      // Load more athletes by increasing the offset and fetching the next batch.
      context.read<AthletesPageCubit>().getAthletes(offset: _loadedAthletes);
      _loadedAthletes += 20;
    }
  }
}
