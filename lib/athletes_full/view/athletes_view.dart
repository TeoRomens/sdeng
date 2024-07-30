import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:sdeng/athletes_full/cubit/athletes_cubit.dart';
import 'package:sdeng/athletes_full/widgets/athlete_tile.dart';

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
    _controller = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<AthletesPageCubit>();

    return RefreshIndicator.adaptive(
      onRefresh: () => bloc.getAthletes(),
      child: Scrollbar(
        controller: _controller,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextBox(
                title: 'All athletes',
                content: 'Below you find all your registered athletes. Tap on a player to see the details.',
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xlg - AppSpacing.xs,
                  AppSpacing.xs,
                  AppSpacing.xlg - AppSpacing.xs,
                  AppSpacing.sm,
                ),
                child: AppTextFormField(
                  onChanged: (text) => context.read<AthletesPageCubit>().searchAthlete(text),
                  prefix: const Icon(FeatherIcons.search),
                  hintText: 'Search',
                ),
              ),
              if (bloc.state.status == AthletesStatus.loading)
                const LoadingBox()
              else if (bloc.state.athletes.isEmpty)
                EmptyState(
                  actionText: 'New athlete',
                  onPressed: () {
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
                                style: Theme.of(context).textTheme.headlineMedium,
                                textAlign: TextAlign.center,
                              ),
                              const Divider(endIndent: 0, indent: 0, height: 25),
                              Padding(
                                padding: const EdgeInsets.all(AppSpacing.sm),
                                child: Text(
                                  'To add a new athlete please go in the team page where you would like to add your athlete',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        )
                    );
                  },
                )
              else
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
                  ),
                  separatorBuilder: (_, index) => const Divider(height: 0, indent: 20),
                ),
              const Divider(indent: 70, height: 0),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  void _scrollListener() {
    if (_controller.position.extentAfter < MediaQuery.of(context).size.height - 100) {
      context.read<AthletesPageCubit>().getAthletes(offset: _loadedAthletes);
      _loadedAthletes += 20;
    }
  }

}
