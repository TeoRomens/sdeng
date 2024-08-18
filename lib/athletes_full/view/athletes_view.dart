import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:sdeng/athlete/athlete.dart';
import 'package:sdeng/athletes_full/athletes.dart';

/// The `AthletesView` widget displays a list of all registered athletes
/// with search functionality and infinite scrolling.
///
/// This widget is a `StatefulWidget` that manages a scroll controller to
/// implement infinite scrolling. It also provides a refresh indicator and a
/// search bar to filter athletes. When the user scrolls near the bottom of the
/// list, more athletes are fetched automatically.
///
/// If there are no athletes available, an empty state is shown with an option
/// to add a new athlete.
@visibleForTesting
class AthletesView extends StatefulWidget {
  const AthletesView({super.key});

  @override
  State<AthletesView> createState() => _AthletesPageScreenState();
}

class _AthletesPageScreenState extends State<AthletesView> {
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
      child: Scrollbar(
        controller: _controller,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TextBox(
                  title: 'All athletes',
                  content:
                  'Below you find all your registered athletes. Tap on a player to see the details.',
                ),
                AppTextFormField(
                  // Search for athletes based on the input text.
                  onChanged: (text) =>
                      context.read<AthletesPageCubit>().searchAthlete(text),
                  prefix: const Icon(FeatherIcons.search),
                  hintText: 'Search',
                ),
                if (bloc.state.status == AthletesStatus.loading)
                  const LoadingBox()
                else if (bloc.state.athletes.isEmpty)
                // Display an empty state if no athletes are found.
                  EmptyState(
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
                                  padding: const EdgeInsets.all(AppSpacing.sm),
                                  child: Text(
                                    'To add a new athlete, please go to the team page where you would like to add your athlete',
                                    style:
                                    Theme.of(context).textTheme.bodyMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ));
                    },
                  )
                else
                // Display the list of athletes if available.
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: bloc.state.athletes.length,
                    itemBuilder: (_, index) => AthleteTile(
                      athlete: bloc.state.athletes[index],
                      trailing: const Padding(
                        padding: EdgeInsets.only(right: AppSpacing.md),
                        child: Icon(FeatherIcons.chevronRight),
                      ),
                      // Navigate to the athlete's details page on tap.
                      onTap: () => Navigator.of(context).push(AthletePage.route(
                          athleteId: bloc.state.athletes[index].id)),
                    ),
                    separatorBuilder: (_, index) =>
                    const Divider(height: 0, indent: 20),
                  ),
                const Divider(indent: 70, height: 0),
                const SizedBox(height: 100),
              ],
            ),
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
