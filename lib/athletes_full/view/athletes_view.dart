import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:sdeng/athletes_full/cubit/athletes_cubit.dart';
import 'package:sdeng/athletes_full/widgets/athlete_tile.dart';

class AthletesPageView extends StatelessWidget {
  const AthletesPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppLogo.light(),
        centerTitle: true,
      ),
      body: BlocListener<AthletesPageCubit, AthletesPageState>(
        listener: (context, state) {
          if (state.status == AthletesStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(state.error)),
              );
          } else if (state.status == AthletesStatus.teamDeleted) {
            Navigator.of(context).pop();
          }
        },
        child: const AthletesPageScreen(),
      ),
    );
  }
}

@visibleForTesting
class AthletesPageScreen extends StatefulWidget {
  const AthletesPageScreen({super.key});

  @override
  State<AthletesPageScreen> createState() => _AthletesPageScreenState();
}

class _AthletesPageScreenState extends State<AthletesPageScreen> {
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
                  onPressed: () {},
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
              Padding(
                padding: const EdgeInsets.only(
                  top: AppSpacing.sm,
                  left: AppSpacing.xlg,
                ),
                child: AppTextButton(
                  text: 'Add athlete',
                  onPressed: () {},
                ),
              ),
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
